Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/' ]}

$base_path = '/usr/local/bin:/usr/local/:/usr/bin/:/bin/'

class systemUpdate{
  exec{'yum update':
    command => 'yum update -y',
    timeout => 0
  }
  $sysPackages = [
    "wget"
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

class devSetup{
  include systemUpdate
  include java
  
  Class[systemUpdate]
  -> Class[java]
}

include devSetup
