module EtcdCookbook
  class EtcdServiceManagerSystemd < EtcdServiceBase
    resource_name :etcd_service_manager_systemd
    provides :docker_service_manager, platform: 'fedora'

    provides :docker_service_manager, platform: %w(redhat centos scientific) do |node| # ~FC005
      node['platform_version'].to_f >= 7.0
    end

    provides :docker_service_manager, platform: 'debian' do |node|
      node['platform_version'].to_f >= 8.0
    end

    provides :docker_service_manager, platform: 'ubuntu' do |node|
      node['platform_version'].to_f >= 15.04
    end

    action :start do
      # Needed for Debian / Ubuntu
      directory '/usr/libexec' do
        owner 'root'
        group 'root'
        mode '0755'
        action :create
      end

      # this script is called by the main systemd unit file, and
      # spins around until the service is actually up and running.
      template "/usr/libexec/#{etcd_name}-wait-ready" do
        source 'systemd/etcd-wait-ready.erb'
        owner 'root'
        group 'root'
        mode '0755'
        variables(etcd_cmd: etcd_cmd)
        cookbook 'etcd'
        action :create
      end

      # this is the main systemd unit file
      template "/lib/systemd/system/#{etcd_name}.service" do
        source 'systemd/etcd.service.erb'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          config: new_resource,
          etcd_name: etcd_name,
          etcd_cmd: etcd_cmd
        )
        cookbook 'etcd'
        notifies :run, 'execute[systemctl daemon-reload]', :immediately
        notifies :restart, new_resource unless ::File.exist? "/etc/#{etcd_name}-firstconverge"
        notifies :restart, new_resource if auto_restart
        action :create
      end

      file "/etc/#{etcd_name}-firstconverge" do
        action :create
      end

      # Avoid 'Unit file changed on disk' warning
      execute 'systemctl daemon-reload' do
        command '/bin/systemctl daemon-reload'
        action :nothing
      end

      # service management resource
      service etcd_name do
        provider Chef::Provider::Service::Systemd
        supports status: true
        action [:enable, :start]
        only_if { ::File.exist?("/lib/systemd/system/#{etcd_name}.service") }
      end
    end

    action :stop do
    end

    action :restart do
      action_stop
      action_start
    end
  end
end
