# Ansible : Playbook Cloudera

The aim of this project is to deploy a Cloudera cluster on Vagrant Linux instances (CentOS).

The Ansible roles used in this project have been developed by the Cloudera community and the original project can be find on Github : https://github.com/cloudera/cloudera-playbook

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

What things you need to run this Ansible playbook :

*   [Vagrant](https://www.vagrantup.com/docs/installation/) must be installed on your computer
*   Update the Vagrant file based on your computer (CPU, memory), if needed
*   Update the operating system to deploy in the Vagrant file (default: CentOS 7)
*   Install the [Vagrant HostManager plugin](https://github.com/devopsgroup-io/vagrant-hostmanager) :

```
$ vagrant plugin install vagrant-hostmanager
```

### Usage

A good point with Vagrant is that you can create, update and destroy all architecture easily with some commands.

Be aware that you need to be in the Vagrant directory to be able to run the commands.

#### Deployment

To deploy Cloudera on Vagrant instances, just run this command :

```bash
$ vagrant up
```

This command should ask you a password needed to get sudo access to create local files in /tmp during the deployment of Cloudera.

If everything run as expected, you should be able to list the virtual machine created :

```bash
$ vagrant status

Current machine states:

clouder01                   running (virtualbox)
clouder02                   running (virtualbox)
clouder03                   running (virtualbox)
clouder04                   running (virtualbox)
```

If everything run as expected, you should have a running Cloudera cluster on the Vagrant instance and should be able to reach the Cloudera Manager web interface : http://10.0.0.11:7180

Default logins are : admin / admin

#### Destroy

To destroy the Vagrant resources created, just run this command :

```bash
$ vagrant destroy
```

### How-To

This section list some simple command to use and manage the playbook and the Vagrant hosts.

#### Update with Ansible

To update the Cloudera configuration with Ansible, you just have to run the Ansible playbook cloudera.yml with this command :

```bash
$ ansible-playbook cloudera.yml
```

#### Update with Vagrant

To update the Cloudera configuration with Vagrant, you just have to run provisioning part of the Vagrant file :

```bash
$ vagrant provision
```

#### Connect to Vagrant instance

To be able to connect to a Vagrant instance, you should use the CLI which is configured to automatically use the default SSH key :

```bash
$ vagrant ssh cloudera01
```

## Author

Member of Wikitops : https://www.wikitops.io/

## Licence

This project is licensed under the Apache License, Version 2.0. For the full text of the license, see the LICENSE file.
