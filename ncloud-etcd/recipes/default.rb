#
# Cookbook Name:: ncloud-etcd
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'ncloud-etcd::_load_key'
etcd_installation_binary node['ncloud-etcd']['service_name'] do
  action :create
end

etcd_service_manager_upstart node['ncloud-etcd']['service_name'] do
  action :start
end

include_recipe 'confd'

service = node['ncloud-etcd']['service_name']

#val = File.read('/tmp/key')
#etcd_key "/foo" do
#  value val
#  action 'set'
  #port 4001
#  port 2379
#end

confd_template '/tmp/foo' do
  template_source 'foo.tmpl.erb'
  prefix node['ncloud-confd']['prefix']
  keys node['ncloud-confd']['keys']

  notifies :restart, "confd_service[#{service}]", :delayed
end
