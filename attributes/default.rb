default['zookeeper']['cluster_name'] = "default"

# ZK defaults
default['zookeeper']['tick_time']   = 2000
default['zookeeper']['init_limit']  = 10
default['zookeeper']['sync_limit']  = 5
default['zookeeper']['client_port'] = 2181
default['zookeeper']['peer_port']   = 2888
default['zookeeper']['leader_port'] = 3888

default['zookeeper']['data_dir']   = "/var/lib/zookeeper/data"
default['zookeeper']['log_dir']   = "/var/log/zookeeper"
default['zookeeper']['version']    = "3.4.5"
default['zookeeper']['source_url'] = "http://mirrors.ibiblio.org/apache/zookeeper/zookeeper-#{node['zookeeper']['version']}"