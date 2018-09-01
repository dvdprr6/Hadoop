Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ]}

$base_path = '/usr/local/bin:/usr/local/:/usr/bin/:/bin/'

class systemUpdate{
  exec{'yum update':
    command => 'yum update -y',
    timeout => 0
  }
  $sysPackages = [
    "wget",
    "telnet",
    "unzip"
  ]
  package {$sysPackages:
    ensure => "installed",
    require => Exec['yum update']
  }
}

class java{
  exec{'download java':
    command => 'wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.tar.gz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/jdk-8u181-linux-x64.tar.gz',
    user => vagrant,
    timeout => 0
  } ->
  exec{'untar java':
    command => 'tar -zxvf jdk-8u181-linux-x64.tar.gz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/jdk1.8.0_181',
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
    command => 'wget http://apache.mirror.colo-serv.net/zookeeper/zookeeper-3.4.13/zookeeper-3.4.13.tar.gz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/zookeeper-3.4.13.tar.gz',
    user => vagrant,
    timeout => 0
  } ->
  exec{'untar zookeeper':
    command => 'tar -zxvf zookeeper-3.4.13.tar.gz',
    cwd => '/home/vagrant',
    creates => '/home/vagrant/zookeeper-3.4.13',
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
  file{'/home/vagrant/zookeeper-3.4.13/conf/zoo.cfg':
    ensure => 'file',
    source => '/home/vagrant/zookeeper-3.4.13/conf/zoo_sample.cfg'
  }
}

class hiveConfig{
  file{'/home/vagrant/apache-hive-2.3.3-bin/conf/hive-site.xml':
    ensure => 'file',
    source => '/vagrant/conf/hive-site.xml'
  }
}

class devSetup{
  include systemUpdate
  include java
  include hadoop
  include zookeeper
  include hive
  include sshKeyGen
  include timezone
  include env
  include hadoopConfig
  include zookeeperConfig
  include hiveConfig
  
  Class[systemUpdate]
  -> Class[java]
  -> Class[hadoop]
  -> Class[zookeeper]
  -> Class[hive]
  -> Class[sshKeyGen]
  -> Class[timezone]
  -> Class[env]
  -> Class[hadoopConfig]
  -> Class[zookeeperConfig]
  -> Class[hiveConfig]
}

include devSetup
