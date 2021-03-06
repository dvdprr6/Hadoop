Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ]}

$base_path = '/usr/local/bin:/usr/local/:/usr/bin/:/bin/'

class systemUpdate{
  exec{'yum update':
    command => 'yum update -y',
    timeout => 0
  }
  $sysPackages = [
    'wget',
    'telnet',
    'unzip'
  ]
  package {$sysPackages:
    ensure => 'installed',
    require => Exec['yum update']
  }
}

class java{
  exec{'download java':
    command => 'wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jdk-8u201-linux-x64.tar.gz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/jdk-8u201-linux-x64.tar.gz',
    user => vagrant,
    timeout => 0
  } ->
  exec{'untar java':
    command => 'tar -zxvf jdk-8u201-linux-x64.tar.gz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/jdk1.8.0_201',
    user => vagrant
  }
}

class hadoop{
  exec{'download hadoop':
    command => 'wget http://apache.mirror.vexxhost.com/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tar.gz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/hadoop-2.7.7.tar.gz',
    user => vagrant,
    timeout => 0
  } ->
  exec{'untar hadoop':
    command => 'tar -zxvf hadoop-2.7.7.tar.gz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/hadoop-2.7.7',
    user => vagrant
  }
}

class zookeeper{
  exec{'download zookeeper':
    command => 'wget http://apache.mirror.colo-serv.net/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/zookeeper-3.4.14.tar.gz',
    user => vagrant,
    timeout => 0
  } ->
  exec{'untar zookeeper':
    command => 'tar -zxvf zookeeper-3.4.14.tar.gz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/zookeeper-3.4.14',
    user => vagrant
  }
}

class hive{
  exec{'download hive':
    command => 'wget http://archive.apache.org/dist/hive/hive-2.3.3/apache-hive-2.3.3-bin.tar.gz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/apache-hive-2.3.3-bin.tar.gz',
    user => vagrant,
    timeout => 0
  } ->
  exec{'untar hive':
    command => 'tar -zxvf apache-hive-2.3.3-bin.tar.gz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/apache-hive-2.3.3-bin',
    user => vagrant
  }
}

class hbase{
  exec{'download hbase':
    command => 'wget https://www.apache.org/dist/hbase/2.1.4/hbase-2.1.4-bin.tar.gz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/hbase-2.1.4-bin.tar.gz',
    user => vagrant,
    timeout => 0
   } ->
   exec{'untar hbase':
    command => 'tar -zxvf hbase-2.1.4-bin.tar.gz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/hbase-2.1.4',
    user => vagrant
  }
}

class kafka{
  exec{'download kafka':
    command => 'wget http://apache.mirror.rafal.ca/kafka/2.1.1/kafka_2.11-2.1.1.tgz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/kafka_2.11-2.1.1.tgz',
    user => vagrant,
    timeout => 0
  } ->
  exec{'untar kafka':
    command => 'tar -zxvf kafka_2.11-2.1.1.tgz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/kafka_2.11-2.1.1',
    user => vagrant
  }
}

class confluent{
  exec{'download confluent':
    command => 'wget http://packages.confluent.io/archive/5.0/confluent-oss-5.0.0-2.11.tar.gz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/confluent-oss-5.0.0-2.11.tar.gz',
    user => vagrant,
    timeout => 0
  } ->
  exec{'untar confluent':
    command => 'tar -zxvf confluent-oss-5.0.0-2.11.tar.gz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/confluent-5.0.0',
    user => vagrant
  }
}

class spark{
  exec{'download spark':
    command => 'wget http://apache.mirror.colo-serv.net/spark/spark-2.4.1/spark-2.4.1-bin-hadoop2.7.tgz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/spark-2.4.1-bin-hadoop2.7.tgz',
    user => vagrant,
    timeout => 0
  } ->
  exec{'untar spark':
    command => 'tar -zxvf spark-2.4.1-bin-hadoop2.7.tgz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/spark-2.4.1-bin-hadoop2.7',
    user => vagrant
  }
}

class scala{
  exec{'download scala':
    command => 'wget https://downloads.lightbend.com/scala/2.12.8/scala-2.12.8.tgz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/scala-2.12.8.tgz',
    user => vagrant,
    timeout => 0
  } ->
  exec{'untar scala':
    command => 'tar -zxvf scala-2.12.8.tgz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/scala-2.12.8',
    user => vagrant
  }
}


class sshKeyGen{
  exec{'generate rsa':
    command => 'ssh-keygen -t rsa -P "" -f /home/vagrant/.ssh/id_rsa',
    cwd => '/home/vagrant/.ssh',
    creates => '/home/vagrant/.ssh/id_rsa',
    user => vagrant
  } ->
  exec{'generate authorized keys':
    command => 'cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys',
    cwd => '/home/vagrant/.ssh',
    user => vagrant
  } ->
  file{'/home/vagrant/.ssh/authorized_keys':
    ensure => 'file',
    owner => vagrant,
    mode => '0600'
  }
}

class timezone{
  exec{'unlink localtime':
    command => 'unlink /etc/localtime',
    cwd => '/home/vagrant',
    user => root
  } ->
  file{'/etc/localtime':
    ensure => 'link',
    target => '/usr/share/zoneinfo/Canada/Eastern',
    owner => root
  }
}

class env{
  exec{'set environment variables':
    command => 'cat /vagrant/env/envVariables >> /home/vagrant/.bashrc',
    cwd => '/home/vagrant',
    user => vagrant
  } ->
  file{'/home/vagrant/.hiverc':
     ensure => 'file',
     source => '/vagrant/env/.hiverc'
  }
}

class hadoopConfig{
  file{'/home/vagrant/hadoop-2.7.7/etc/hadoop/core-site.xml':
    ensure => 'file',
    source => '/vagrant/conf/core-site.xml'
  } ->
    file{'/home/vagrant/hadoop-2.7.7/etc/hadoop/hdfs-site.xml':
    ensure => 'file',
    source => '/vagrant/conf/hdfs-site.xml'
  } ->
    file{'/home/vagrant/hadoop-2.7.7/etc/hadoop/mapred-site.xml':
    ensure => 'file',
    source => '/vagrant/conf/mapred-site.xml'
  } ->
    file{'/home/vagrant/hadoop-2.7.7/etc/hadoop/yarn-site.xml':
    ensure => 'file',
    source => '/vagrant/conf/yarn-site.xml'
  }
}

class zookeeperConfig{
  file{'/home/vagrant/zookeeper-3.4.14/conf/zoo.cfg':
    ensure => 'file',
    source => '/home/vagrant/zookeeper-3.4.14/conf/zoo_sample.cfg'
  }
}

class hiveConfig{
  file{'/home/vagrant/apache-hive-2.3.3-bin/conf/hive-site.xml':
    ensure => 'file',
    source => '/vagrant/conf/hive-site.xml'
  }
}

class hbaseConfig{
  file{'/home/vagrant/hbase-2.1.4/conf/hbase-site.xml':
    ensure => 'file',
    source => '/vagrant/conf/hbase-site.xml'
  }
}

class kafkaConfig{
  file{'/home/vagrant/kafka_2.11-2.1.1/config/server-0.properties':
    ensure => 'file',
    source => '/vagrant/conf/server-0.properties'
  } ->
  file{'/home/vagrant/kafka_2.11-2.1.1/config/server-1.properties':
    ensure => 'file',
    source => '/vagrant/conf/server-1.properties'
  }
}

class devSetup{
  include systemUpdate
  include java
  include hadoop
  include zookeeper
  include hive
  include hbase
  include kafka
  include confluent
  include spark
  include scala
  include sshKeyGen
  include timezone
  include env
  include hadoopConfig
  include zookeeperConfig
  include hiveConfig
  include hbaseConfig
  include kafkaConfig
  
  Class[systemUpdate]
  -> Class[java]
  -> Class[hadoop]
  -> Class[zookeeper]
  -> Class[hive]
  -> Class[hbase]
  -> Class[kafka]
  -> Class[confluent]
  -> Class[spark]
  -> Class[scala]
  -> Class[sshKeyGen]
  -> Class[timezone]
  -> Class[env]
  -> Class[hadoopConfig]
  -> Class[zookeeperConfig]
  -> Class[hiveConfig]
  -> Class[hbaseConfig]
  -> Class[kafkaConfig]
}

include devSetup
