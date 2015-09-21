default['fail2ban']['services'] = {
  'ssh' => {
    "enabled" => "true",
    "port" => "ssh",
    "filter" => "sshd",
    "logpath" => node['fail2ban']['auth_log'],
    "maxretry" => "6"
  }
}
default['cog_ips']['suricata_version'] = '2.0.8'
default['cog_ips']['rules_deploy_vault'] = 'cog_ips'
default['cog_ips']['rules_deploy_bucket'] = 'deploykeys'
default['cog_ips']['rules_repo'] = 'git@github.com:cog-peachy/chef-peachy_ips-rules.git'
