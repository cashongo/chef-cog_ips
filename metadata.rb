name             'cog_ips'
maintainer       'Cash On Go Ltd'
maintainer_email 'lauri.jesmin@cashongo.co.uk'
license          'All rights reserved'
description      'Installs/Configures cog_ips'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.6.2'

depends         'yum-epel'
depends         'chef-vault'
depends         'runit'
depends         'cog_deploy_key'
