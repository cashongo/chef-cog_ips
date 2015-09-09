#This recipe installs and configures a IPS on a machine


include_recipe 'fail2ban'

suricata_version = '2.0.8'
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

['libnetfilter_queue-devel','libpcap-devel', 'make', 'gcc','pcre-devel','libyaml-devel','file-devel','zlib-devel','jansson-devel','nss-devel','libcap-ng-devel','libnet-devel','supervisor','perl','perl-Getopt-Long','wget' ].each do |n|
  package n
end

execute "Configure suricata build" do
  command "./configure --enable-nfqueue --prefix=/usr --sysconfdir=/etc --localstatedir=/var"
  cwd "/root/suricata-#{suricata_version}"
  not_if { ::File.exists?("/root/suricata-#{suricata_version}/config.log")}
end

execute "Build suricata" do
  command "make"
  cwd "/root/suricata-#{suricata_version}"
  not_if { ::File.exists?("/root/suricata-#{suricata_version}/src/.libs/suricata")}
end

execute "Install suricata" do
  command "make install-full"
  cwd "/root/suricata-#{suricata_version}"
  not_if { ::FileUtils.identical?('/usr/bin/suricata',"/root/suricata-#{suricata_version}/src/.libs/suricata")}
end

execute "ldconfig" do
  command "ldconfig"
end

directory "/var/log/suricata" do
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

['classification.config','reference.config','suricata.yaml'].each do |n|
  cookbook_file "/etc/suricata/#{n}" do
    source n
    owner 'root'
    group 'root'
    mode '0600'
    action :create
  end
end

cookbook_file '/etc/supervisord.d/suricata.ini' do
  source 'suricata_supervisor.conf'
  owner 'root'
  group 'root'
  mode '0600'
  action :create
end

service 'supervisord' do
  action [:enable, :start]
end
