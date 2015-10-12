cog_ips Cookbook
================

This cookbook installs suricata to your linux. It uses supervisor for managing suricata process
(systemd is not universally available)

It uses fail2ban supermarket cookbook https://supermarket.chef.io/cookbooks/fail2ban to control
ssh.

I do not expect any other local service running/ports open in local machine, so
i have made no effort to contain IN/OUT traffic from machine, only forwarded
traffic.

Download suricata latest version source from http://suricata-ids.org/download/ and put
this file to files/default directory.

Attributes
----------

#### cog_ips::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['cog_ips']['suricata_version']</tt></td>
    <td>String</td>
    <td>Installed suricata version</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['cog_ips']['rules_deploy_vault']</tt></td>
    <td>String</td>
    <td>Vault name for deploy key</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['cog_ips']['rules_deploy_bucket']</tt></td>
    <td>String</td>
    <td>Bucket inside vault for deploy key</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['cog_ips']['rules_repo']</tt></td>
    <td>String</td>
    <td>Suricata rules repository url</td>
    <td><tt>true</tt></td>
  </tr>
</table>


Usage
-----
#### cog_ips::default

Include `cog_ips` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[cog_ips]"
  ]
}
```

You also need iptables rules for sending network traffic to suricata instead of
going through untouched.

Firewall rules
--------------

In case of IPS (possible to drop packets) those rules should be applied:

```
iptables -A FORWARD -j NFQUEUE --queue-bypass --queue-num 1
iptables -A INPUT  -j NFQUEUE --queue-bypass --queue-num 1
iptables -A OUTPUT  -j NFQUEUE --queue-bypass --queue-num 1
```

In case of IDS (just watching traffic) those rules should be applied

```
iptables -A INPUT -j NFLOG --nflog-group 2
iptables -A OUTPUT -j NFLOG --nflog-group 2
iptables -A FORWARD -j NFLOG --nflog-group 2
```


Oinkmaster
----------

Running oinkmaster:
oinkmaster.pl -C /etc/oinkmaster.conf -o /etc/suricata/rules

This changes files in /etc/suricata/rules, remember to sync changes to ghithub!

Best way to update rules would be to download and test rules in workstation
then update github and then let machine deploy them.
