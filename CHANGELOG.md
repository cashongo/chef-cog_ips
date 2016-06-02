# 0.5.0
- replace deploy key logic with specific deploy key handler resource

# 0.4.0
- update documentation about rules
- remove fail2ban dependency, this is managed by cog_security

# 0.3.1
- restrict some rule updates from oinkmaster

# 0.3.0
- update to suricata 3.0.1

# 0.2.1 (2016-02-03)
- Add new options to suricata.yaml (log netflow, smtp)

# 0.2.0 (2016-02-03)
- Change build options
- update suricata to 3.0

# 0.1.13 (2015-12-02)
- set detection engine profile low
- update suricata to 2.0.10

# 0.1.12 (2015-11-23)
- set suricata log destination to syslog and log level to info
- enable live reload of rules
- fix invalid action on configuration update

# 0.1.11 (2015-11-23)
- compression on for logrotate
- rotation set explicitly to daily

# 0.1.10 (2015-11-23)
- Check out rules from git, even if rules dir exists

# 0.1.9 (2015-11-18)
- Disable http log and fast.log, eve.json is enough

# 0.1.8 (2015-10-14)
- disable stats log, wastes space with no use
- insert firewall rules at suricata startup

# 0.1.6 (2015-10-13)
- change suricata to use NFLOG instead of NFQ
- disable unified log, IDK what is barnyard2

# 0.1.4
- upgrade suricata to 2.0.9
- fix install of suricata executable

# 0.1.3
- adjusted deploy key logic
- replaced supervisor with runit

# 0.1.0
- Initial release of cog_ips
