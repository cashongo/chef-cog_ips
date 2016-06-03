name             'cog_ips'
maintainer       'Cash On Go Ltd'
maintainer_email 'lauri.jesmin@cashongo.co.uk'
license          'All rights reserved'
description      'Installs/Configures cog_ips'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.5.0'

depends         'yum-epel',   '~> 0.6.2'
depends         'chef-vault', '~> 1.3.0'
depends         'runit',      '~> 1.5.10'
depends         'cog_deploy_key', '~> 0.1.0'
