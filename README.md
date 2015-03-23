# vagrant-specify7

## Description

Package to quickly launch a [Specify7](http://specifysoftware.com) instance inside a [Vagrant VM](https://www.vagrantup.com/).

## Step by Step Instructions

Step) Description: *execute command in the terminal*

1) Clone this repository: *git clone http://github.com/aafc-mbb/specify7-vagrant

2) Rename or copy the *specify_settings.py.sample* file as *specify_settings.py* and edit as required (MASTER_NAME, MASTER_PASSWORD, etc.)

3) Modify relevant configuration in *config.yml*
  * See networking section for more information on private vs public networking (VirtualBox and libvirt providers only)
  * See the hypervisor support section for more information

4) Install vagrant:
  * Debian/Ubuntu: *sudo apt-get install vagrant*
  * RHEL/CentOS: Download vagrant from https://www.vagrantup.com/downloads.html

5) Initialize the VM and wait for provisioning to complete: *vagrant up*
  * To use the libvirt or OpenStack provider, see the Hypervisor Support section.  Defaults to VirtualBox.


## Hypervisor Support

### VirtualBox (default)

For this hypervisor, modifications are not required.  Folders between the hypervisor and host are synced using VirtualBox's Shared Folders.  This hypervisor permits using a Windows, Linux, or Mac host.

Ensure that you have VirtualBox installed before continuing.

Inside the GIT repository you cloned, start the VM using
> vagrant up

### libvirt

Support for the libvirt provider allows using several underlying hypervisors through the libvirt api. KVM is the default hypervisor, which is supported using most modern Linux hosts.

Ensure that you have installed the libvirt, kvm, and all relevant system packages and are able to start a KVM Virtual Machine before using this repository. 
The [vagrant-libvirt plugin](https://github.com/pradels/vagrant-libvirt) is required before issuing a vagrant up command.

Inside the GIT repository you cloned, start the VM with libvirt using
> vagrant up --provider=libvirt

### OpenStack

The [vagrant-openstack-plugin](https://github.com/cloudbau/vagrant-openstack-plugin) is required before issuing a vagrant up command.  This plugin is only compatible with Vagrant 1.4+ and can be installed using:
> vagrant plugin install vagrant-openstack-plugin

In addition, a dummy box must be installed as it is required for Vagrant to function:
> vagrant box add dummy https://github.com/cloudbau/vagrant-openstack-plugin/raw/master/dummy.box

Generate a private/public key pair to use for SSHing into the VM and register it in Openstack and your workstation.  See [Openstack's documentation](http://docs.openstack.org/user-guide/content/Launching_Instances_using_Dashboard.html) for more information.

#### Configuration

The openstack provider requires some configuration in *config.yml* under the vm->provider->openstack section.  

*NOTE: This provider ignores the vm->networking section config.yml completely!*

See the following for a brief explanation of the options.

      enabled: true | false - Set to 'true' if you want to use the openstack provider (vagrant-openstack-plugin required)
      box: dummy - Name of the empty box to user. This is a limitation of Vagrant.
      vm-name: 'Specify7' - Name of the instance that you will see in OpenStack
      box-url: https://github.com/cloudbau/vagrant-openstack-plugin/raw/master/dummy.box - Place holder
      username: admin - OpenStack identity/authentication username
      api-key: admin - OpenStack identity/authentication password.
      flavor: m1.small - Name of VM flavor to use. m1.small, m1.medium, etc are default flavours in openstack. They control the VM's cpu, mem, and storage paremeters.
      project-name: admin | - The project name to use. Leave empty to use the default project for your account.
      image: Ubuntu 14.04 Trusty - The base image to use (must be available in OpenStack).  This Vagrantfile is based on and tested on Debian 6 and Ubuntu 14.04 only.
      identity-auth-url: http://openstack-test.biodiversity.agr.gc.ca:5000/v2.0/tokens - URL to identity service appended by "/tokens"
      ssh-username: ubuntu - The username used to SSH into the VM, which is typically defined in the image (default is ubuntu for Ubuntu cloud images)
      ssh-key-path: ~/.ssh/cloud.key - Location of the SSH private key on disk. You must generate a private/public key pair abd unoirt the public key to openstack.
      keypair-name: iyad - Name of the private/public key pair defined in OpenStack.  You must generate a private/public key pair and import the public key to openstack.
      floating-ip: 192.168.0.100 | auto | - Provide a floating-ip address, or set to 'auto', or leave it empty. This will be the IP used to access the VM.  If left empty, the nova network IP will be used.

#### Starting VM

Insite the GIT repository you cloned, start the VM with OpenStack using
> vagrant up --provider=openstack

#### Limitations

* Not all openstack functionality is integrated into this Vagrantfile.  Adding additional functionality through the config.yml should be relateively simple.
* The openstack provider does not "share" folders (e.g. /ipt_data) but rather rsyncs their content from provisioner to the VM.  Hence, the data lives in the VM and is lost when the VM is terminated!

## Networking

Two networking options are supported: *private* and *public*.  Modify *config.yml* and edit the *networking->type* parameter to switch between these two modes.  You can change this option and reload the VM using
> vagrant reload --provision

Note: The OpenStack provider ignores the networking section in config.yml completely.  If using the OpenStack provider, please skip this section.

### Private networking

Vagrant establishes a network between the hypervisor and its VMs where traffic flow into the VM must be explicitly forwarded to the VM by defining port forwarding.  Hence, the VM's IP is not accessible from outside the VM.  This is advantageous when IPs are limited or adding DNS records is not possible, which means you are relying on an existing hostname and IP.  Nevertheless, this creates the need for port forwarding from the Host (Hypervisor) to the Guest, which causes a management overhead.  To specify the forwarded ports, modify *config.yml* and add/remove entries in *networking->private->port-forward* with a *guest-port: host-port* syntax.

### Public Networking

Vagrant creates a bridge interface to a logical device on the host (Hypervisor) and pass traffic through to it from the VM.  This permits assigning the VM a "public" IP and avoid the need for port forwarding.  Currently, DHCP is not supported.  Edit *config.yml* and modify the *ip*, *gateway*, *dns* parameters under *networking->public* accordingly.


## Credits

The following contributors have dedicated the time and effort to make this possible.

Allan Joneshttps://github.com/AAFC-MBB/vagrant-specify7/wiki
Agriculture & Agri-Foods Canada

Iyad Kandalaft
Agriculture & Agri-Foods Canada

If you feel that your name should be on this list, please make a pull request listing your contributions.
