#This recipe installs and configures a IPS on a machine

include_recipe 'chef-vault'
include_recipe 'runit'

suricata_version = node['cog_ips']['suricata_version']

cookbook_file "/root/suricata-#{suricata_version}.tar.gz" do
  source "suricata-#{suricata_version}.tar.gz"
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

execute 'Extract suricata source' do
  command "tar zxf /root/suricata-#{suricata_version}.tar.gz"
  cwd '/root'
  not_if {  ::File.exists?("/root/suricata-#{suricata_version}/configure") }
end

['libnetfilter_queue-devel','libnetfilter_log-devel','libpcap-devel', 'make', 'gcc','pcre-devel','libyaml-devel','file-devel','zlib-devel','jansson-devel','nss-devel','libcap-ng-devel','libnet-devel','perl','perl-Getopt-Long','wget' ].each do |n|
  package n
end

execute "Configure suricata build" do
  command "./configure --enable-nfqueue --enable-nflog --prefix=/usr --sysconfdir=/etc --localstatedir=/var"
  cwd "/root/suricata-#{suricata_version}"
  not_if { ::File.exists?("/root/suricata-#{suricata_version}/config.log")}
end

execute "Build suricata" do
  command "make"
  cwd "/root/suricata-#{suricata_version}"
  not_if { ::File.exists?("/root/suricata-#{suricata_version}/src/.libs/suricata")}
end

execute "Install suricata" do
  command "make install"
  cwd "/root/suricata-#{suricata_version}"
  only_if { !::File.exists?('/usr/bin/suricata') || !::FileUtils.identical?('/usr/bin/suricata',"/root/suricata-#{suricata_version}/src/.libs/suricata")}
end

execute "ldconfig" do
  command "ldconfig"
end

directory "/var/log/suricata_ips" do
  owner 'root'
  group 'root'
  mode '0700'
  action :create
end

directory "/etc/suricata" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file "/usr/bin/oinkmaster.pl" do
  source "oinkmaster.pl"
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

cookbook_file '/etc/oinkmaster.conf' do
  source 'oinkmaster.conf'
  owner 'root'
  group 'root'
  mode '0600'
  action :create
end

directory "/etc/suricata" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

package 'git'

#### deploy key stuff

keys = chef_vault_item( node['cog_ips']['rules_deploy_vault'], node['cog_ips']['rules_deploy_bucket'] )

deploy_key node['cog_ips']['rules_deploy_key'] do
  key_location '/root/.ssh'
  key_content keys[node['cog_ips']['rules_deploy_key']]
  user 'root'
  action :create
end

template "/root/rules_ssh_wrapper.sh" do
  action :create
  source "ssh_wrapper.erb"
  mode '0755'
  owner 'root'
  group 'root'
  variables({
    :keypath => "/root/.ssh/#{node['cog_ips']['rules_deploy_key']}",
  })
end

#### end deploy key stuff

directory "/etc/suricata/rules_repo" do
  only_if { File.exist?("/etc/suricata/rules_repo") }
  action :delete
  recursive true
end

git '/etc/suricata/rules_repo' do
  action :checkout
  user 'root'
  group 'root'
  ssh_wrapper "/root/rules_ssh_wrapper.sh"
  repository node['cog_ips']['rules_repo']
  notifies :usr2, 'runit_service[suricata]', :delayed
  not_if { File.exist?('/etc/suricata/rules/.git') }
end

directory '/etc/suricata/rules' do
  action :delete
  recursive true
  not_if { File.exist?('/etc/suricata/rules/.git') }
end

ruby_block 'Rename rules dir' do
  block do
    ::File.rename('/etc/suricata/rules_repo','/etc/suricata/rules')
  end
  not_if { File.exist?('/etc/suricata/rules/.git') }
end

git "/etc/suricata/rules" do
  action :sync
  user 'root'
  group 'root'
  ssh_wrapper "/root/rules_ssh_wrapper.sh"
  repository node['cog_ips']['rules_repo']
  notifies :usr2, 'runit_service[suricata]', :delayed
end

['classification.config','reference.config','suricata.yaml'].each do |file|
  cookbook_file "/etc/suricata/#{file}" do
    source file
    owner 'root'
    group 'root'
    mode '0600'
    action :create
    # USR2 signal to suricata reloads rules
    notifies :restart, 'runit_service[suricata]', :delayed
  end
end

cookbook_file "/usr/local/bin/suricata_firewall_rules.sh" do
  source 'suricata_firewall_rules.sh'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

runit_service 'suricata' do
  default_logger true
  action [ :enable, :start ]
end


cookbook_file "/etc/logrotate.d/suricata" do
  source "suricata_logrotate.conf"
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end
