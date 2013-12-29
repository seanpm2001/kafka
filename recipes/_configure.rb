#
# Cookbook Name:: kafka
# Recipe:: _configure
#

template File.join(node[:kafka][:config_dir], node[:kafka][:log4j_config]) do
  source  'log4j.properties.erb'
  owner node[:kafka][:user]
  group node[:kafka][:group]
  mode  '644'
  variables(
    process: 'kafka',
    log_dir: node[:kafka][:log_dir]
  )
end

template File.join(node[:kafka][:config_dir], node[:kafka][:config]) do
  source  'server.properties.erb'
  owner node[:kafka][:user]
  group node[:kafka][:group]
  mode  '644'
end

template '/etc/init.d/kafka' do
  source 'initd.script.erb'
  owner 'root'
  group 'root'
  mode '755'
  variables(
    daemon_name:   'kafka',
    main_class:    'kafkaServer kafka.Kafka',
    jmx_port:      node[:kafka][:jmx_port],
    config:        node[:kafka][:config],
    log4j_config:  'log4j.properties'
  )
end

service 'kafka' do
  supports start: true, stop: true, restart: true
  action [:enable]
end