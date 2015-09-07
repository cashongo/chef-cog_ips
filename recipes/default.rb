#
# Cookbook Name:: cog_ips
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


include_recipe 'yum-epel'
include_recipe 'cog_ips::ips'
