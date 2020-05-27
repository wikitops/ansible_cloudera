# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 2.0.0"

# List of supported operating systems
SUPPORTED_OS = {
  "centos6"   => {box: "centos/6", bootstrap_os: "centos", user: "vagrant"},
  "centos7"   => {box: "centos/7", bootstrap_os: "centos", user: "vagrant"}
}

# Vagrant instance management
$os                       = "centos7"
$num_instances            = 4
$instance_name_prefix     = "cloudera"
$vm_memory                = 4096
$vm_cpus                  = 2
$subnet                   = "10.0.0.1" # For 10.0.0.1X
$box                      = SUPPORTED_OS[$os][:box]
$box_version              = SUPPORTED_OS[$os][:box_version]

# Ansible provisioner
$playbook                 = "cloudera.yml"

# if $inventory is not set, try to use example
$inventory                = File.join(File.dirname(__FILE__), "inventory") if ! $inventory

# Ansible host vars
host_vars                 = {}

# if $inventory has a hosts file use it, otherwise copy over vars etc
# to where vagrant expects dynamic inventory to be.
if ! File.exist?(File.join(File.dirname($inventory), "hosts"))
  $vagrant_ansible = File.join(File.dirname(__FILE__), ".vagrant", "provisioners", "ansible")
  FileUtils.mkdir_p($vagrant_ansible) if ! File.exist?($vagrant_ansible)
  if ! File.exist?(File.join($vagrant_ansible, "inventory"))
    FileUtils.ln_s($inventory, File.join($vagrant_ansible, "inventory"))
  end
end

Vagrant.configure("2") do |config|

  # Configure hosts file
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  # always use Vagrants insecure key
  config.ssh.insert_key = false
  config.ssh.username   = SUPPORTED_OS[$os][:user]

  # Configure box
  config.vm.box         = $box
  config.vm.box_version = $box_version

  (1..$num_instances).each do |i|

    config.vm.provider "virtualbox" do |vb|
      vb.memory         = $vm_memory
      vb.cpus           = $vm_cpus
    end

    config.vm.define vm_name = "%s%02d" % [$instance_name_prefix, i] do |server|
      server.vm.hostname = vm_name
      server.vm.network "private_network", ip: "#{$subnet}#{i}"

      host_vars[vm_name] = {
        "ip": "#{$subnet}#{i}"
      }

      # # Only execute the Ansible provisioner when all the machines are up and ready
      if i == $num_instances
        server.vm.provision "ansible" do |ansible|
          ansible.compatibility_mode  = "2.0"
          ansible.playbook            = $playbook
          if File.exist?(File.join(File.dirname($inventory), "hosts"))
            ansible.inventory_path    = $inventory
          end
          ansible.host_vars           = host_vars
          ansible.become              = true
          ansible.ask_become_pass     = true
          ansible.limit               = "all"
          ansible.host_key_checking   = false
          ansible.groups = {
            "worker_servers:vars"         => {
              "host_template"             => "HostTemplate-Workers"
            },
            "scm_server"                  => ["#{$instance_name_prefix}0[1:1]"],
            "db_server"                   => ["#{$instance_name_prefix}0[1:1]"],
            "krb5_server"                 => [""],
            "utility_servers:children"    => ["scm_server", "db_server", "krb5_server"],
            "edge_servers"                => ["#{$instance_name_prefix}0[2:2] host_template=HostTemplate-Edge role_ref_names=HDFS-HTTPFS-1"],
            "master_servers"              => ["#{$instance_name_prefix}0[3:3] host_template=HostTemplate-Master1"],
            "worker_servers"              => ["#{$instance_name_prefix}0[4:4]"],
            "cdh_servers:children"        => ["utility_servers", "edge_servers", "master_servers", "worker_servers"]
          }
        end
      end
    end
  end
end
