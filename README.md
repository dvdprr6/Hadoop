# Hadoop Vagrant

The purpose of this project is to create a quick and easy VM that supports Pseudo-Distributed Hadoop environment for development

## Requirements
Before creating your VM you need the following tools. Download and install the latest versions of 
- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)

## Vagrant Setup
Once the required tools and software have been successfully installed, the next step would be to setup Vagrant to create and manage the VM. The virtual vagrant box that is currently supported is centos7.

On the command line download Vagrant's centos7 box:

```
$ vagrant box add centos/7
```

For a complete list of boxes that Vagrant supports please visit: https://app.vagrantup.com/boxes/search

Running the following command will list the boxes that have have been download

```
$ vagrant box list
```

Now install Vagrant's VirtualBox Guest Additions plutgin so that Vagrant can work with VirtualBox properly

```
$ vagrant plugin install vagrant-vbguest
```

## Edit local hosts file
To be able to open Hadoop's dashboard on your local browser add the following to your hosts file ```/etc/hosts```

```
127.0.0.1   vagrant-hadoop-centos7
```

Now restart your local machine

## VM Setup

After downloading this repository, navigate to ```vagrant-setup-centos7``` directory and run

```
$ vagrant up
```

This will read the Vagrantfile and use the puppet scripts to provision and get the VM ready for Hadoop. NOTE: It may take several minutes to get the VM ready.

Once the VM has been finished being provisioned, run this command to enter the VM

```
$ vagrant ssh
```

By default this command will place you in ```/home/vagrant/``` home directory.

## Start Hadoop

Once in the VM run the following command to format the filesystem for Hadoop

```
[vagrant@vagrant-hadoop-centos7 ~]$ hdfs namenode -format
```

Now start the NameNode daemon and the DataNode daemon

```
[vagrant@vagrant-hadoop-centos7 ~]$ start-dfs.sh
```

## Start YARN

Start YARN by running the following command:

```
[vagrant@vagrant-hadoop-centos7 ~]$ start-yarn.sh
```

## Create HDFS Home Directory
We need a place to put our data on HDFS, this directory is not created by default and this is the directory HDFS will look into to find data:

```
[vagrant@vagrant-hadoop-centos7 ~]$ hadoop fs -mkdir -p /user/vagrant
```
## Create Hive Home Directory on HDFS
We need a place to store the metadata and/or data for Hive, create this directory on the HDFS

```
[vagrant@vagrant-hadoop-centos7 ~]$ hadoop fs -mkdir -p /user/hive/warehouse
```

## Configure Hive
In Hive version 2.3.3 we need to initialize derby by running this command:

```
[vagrant@vagrant-hadoop-centos7 ~]$ schematool -initSchema -dbType derby
```
## Start Zookeeper
Start Zookeeper by running the following command:

```
[vagrant@vagrant-hadoop-centos7 ~]$ zkServer.sh start
```

## Zookeeper CLI
To access Zookeeper's CLU run the following command:

```
[vagrant@vagrant-hadoop-centos7 ~]$ zkCli.sh
```

## Start HBase

Start HBase by running the following command:

```
[vagrant@vagrant-hadoop-centos7 ~]$ start-hbase.sh
```

## Start Kafka
Start Kafka brokers by running the following command:

```
[vagrant@vagrant-hadoop-centos7 ~]$ kafka-server-start.sh $KAFKA_HOME/config/server-0.properties
```

```
[vagrant@vagrant-hadoop-centos7 ~]$ kafka-server-start.sh $KAFKA_HOME/config/server-1.properties
```

## Start Confluent
Start Confluent by running these commands:

```
[vagrant@vagrant-hadoop-centos7 ~]$ cd /home/vagrant/confluent-5.0.0
```

```
[vagrant@vagrant-hadoop-centos7 ~]$ bin/confluent start
```

## Testing

At this point navigate your browser to http://vagrant-hadoop-centos7:50070 and verify Hadoop's Dashboard is dispayed. Go to the Datanodes tab and verify that one datanode it active in the Datanode usage histogram

Verify that YARN is running by navigating to http://vagrant-hadoop-centos7:8088

Now your VM is ready to use Hadoop!

## References
- Vagrant Documentation: https://www.vagrantup.com/docs/index.html
- Hadoop Quick Installation guide: https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html#Pseudo-Distributed_Operation
- Hadoop Download link: http://www.apache.org/dyn/closer.cgi/hadoop/common
- Kafka Documentation: https://kafka.apache.org/
- Confluent Quick Start Guide: https://docs.confluent.io/current/quickstart/cos-quickstart.html#cos-quickstart
- Spark Quick Start Guide: https://spark.apache.org/docs/2.2.0/quick-start.html

