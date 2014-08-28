#Bamboo
[![Build Status](https://travis-ci.org/mukaibot/puppet-bamboo.svg?branch=production)](https://travis-ci.org/mukaibot/puppet-bamboo)

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with Bamboo](#setup)
    * [What Bamboo affects](#what-bamboo-affects)
    * [Setup requirements](#setup-requirements)
4. [Usage - How to use the module](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Public Classes](#public-classes)
    * [Private Classes](#private-classes)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

##Overview

Installs Bamboo on a server, with a local Postgres instance. By default, you get Bamboo 5.5.1, Postgres 9.3 and Java 1.7.

##Module Description

This module will install Bamboo 5.5 on your server. It also installs Postgres 9.3, and creates a database and user for you. Currently, it does not configure Bamboo to point to the database - you will need to do that yourself.

##Setup

###What Bamboo affects

* Java JDK
* Postgresql

###Setup Requirements

Mandatory requirements:
  nanliu/staging
  puppetlabs/stdlib

Optional requirements:
  puppetlabs/postgresql
  puppetlabs/java

Note that the default configuration of the module makes used of all these requirements.

Do not define your bamboo user separately, use this module to do it.
 
##Usage

```puppet
class { '::bamboo':
  username        => 'bamboo',
  pass_hash       => '$6$XZ3WAndARKKP9d$gv8gsLeoaaKuWD5pPF86V3Y8lb6OdhmEntFrpZeCf2NYX4pnRs5PrRdjcVOGVzeqrHLaZoUVKXNUEpjIr8rcP/',
  bamboo_version  => '5.5.1',
  bamboo_home     => '/home/bamboo/data',
  bamboo_data     => '/var/bamboo/data',
  java_manage     => true,
  db_manage       => true,
  db_name         => 'bamboo_db',
  db_pass         => 'awesomepass',
}
```

##Reference

### Classes

####Public Classes

* bamboo: Main class, includes all other classes.

####Private Classes

* bamboo::database: Selects the database to install.
* bamboo::database::postgresql: Manage the PG database for bamboo.
* bamboo::install: Download and install Bamboo.
* bamboo::java: Install and configure java.
* bamboo::params: Default values for parameters.
* bamboo::service: Manage the bamboo service.
* bamboo::user: Creates the user and required directories.

####Parameters

The following parameters are valid for bamboo:

####`username`

The username for the bamboo user. Default is `bamboo`

####`pass_hash`

Password hash for the bamboo user. Use the mkpassword -m sha-512 command to set this. eg
`$6$XZ3WAndARKKP9d$gv8gsLeoaaKuWD5pPF86V3Y8lb6OdhmEntFrpZeCf2NYX4pnRs5PrRdjcVOGVzeqrHLaZoUVKXNUEpjIr8rcP/`

####`bamboo_version`

Version of Bamboo to install. Default is `5.5.1`

####`bamboo_home`

Path to the directory bamboo should use for installing the software. Default is `/opt/atlassian/bamboo`

####`bamboo_data`

Path to the directory bamboo will store it's data in. Default is `/var/atlassian/application-data/bamboo`

####`bamboo_url`

The url to the bamboo download.

####`db_manage`

Specify whether or not puppet should manage a database. Default is `true`.

####`db_type`

The type of database to install.  Currently only postgres is supported, but there are plans to add mysql.

####`db_name`

The name of the database for bamboo to use.

####`db_user`

The database user for bamboo.

####`db_pass`

The database password for bamboo.

####`java_manage`

Specify whether or not puppet should manage java (jdk/jre).

####`java_distribution`

Specify to use the jdk, or jre.

####`java_version`

The version of java to install.  Default will use the system default.

####`java_pacakge`

Then name of the java package to install.

####`service_manage`

Specify whether or not puppet will manage the bamboo service.

####`service_ensure`

Specify whether the service should be running or stopped.

####`service_enable`

Specify whether the service should start at boot time.

####`service_name

The name of the bamboo service.

##Limitations

This module has only been tested on Centos 6.5, but it should be ok with Ubuntu/Debian too.

## Todo list:

* Add a ton more spec tests
* Add acceptance tests
* Add mysql support
* Add variable validation
* Add class documentation
* Add example wrapper class in the documentation
* Add code to install Bamboo addons.

##Testing

```shell
bundle rake install
bundle rake spec
  or
bundle rake spec_standalone
```

##Development

Pull requests are welcome. Please use a feature branch.
