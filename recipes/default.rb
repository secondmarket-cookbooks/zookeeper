#
# Cookbook Name:: zookeeper
# Recipe:: default
#
# Copyright 2010, GoTime Inc.
# Copyright 2013, SecondMarket Labs, LLC.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe "java"

package "zookeeper" do
  action :install
end

template "/etc/zookeeper/log4j.properties" do
  source "log4j.properties.erb"
  mode 0644
end

if node.recipe?("zookeeper")
  zk_servers = [node]
else
  zk_servers = []
end

zk_servers += search(:node, "role:zookeeper AND chef_environment:#{node.chef_environment} AND zookeeper_cluster_name:#{node['zookeeper']['cluster_name']} NOT name:#{node.name}") # don't include this one, since it's already in the list

zk_servers.sort! { |a, b| a.name <=> b.name }

template "/etc/zookeeper/zoo.cfg" do
  source "zoo.cfg.erb"
  mode 0644
  variables(:servers => zk_servers)
end

service "zookeeper" do
  supports :status => true, :restart => true, :reload => true
  action :enable
  subscribes :restart, resources(:template => "/etc/zookeeper/zoo.cfg")
end

directory node['zookeeper']['data_dir'] do
  recursive true
  owner "zookeeper"
  mode 0755
end

myid = zk_servers.collect { |n| n[:ipaddress] }.index(node[:ipaddress])

template "#{node['zookeeper']['data_dir']}/myid" do
  source "myid.erb"
  owner "zookeeper"
  variables(:myid => myid)
end

service "zookeeper" do
  action :start
end
