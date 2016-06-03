
default['ncloud-etcd']['service_name'] = 'ncloud'
default['confd']['service_name'] = node['ncloud-etcd']['service_name']
default['confd']['config'] = {
  'backend' => 'etcd',
  'confdir' => '/etc/confd',
  'interval' => 600,
  'nodes' => 'http://127.0.0.1:2379',
  'noop' => false,
  'scheme' => 'http'
}

default['ncloud-confd']['prefix'] = '/'
default['ncloud-confd']['keys'] = '/foo'


default['build-essential']['compile_time'] = true
