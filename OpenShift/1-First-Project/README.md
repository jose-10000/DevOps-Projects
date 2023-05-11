# CodeReady Containers
This cluster provides a minimal environment for development and testing purposes. It’s mainly targetted at running on developers' desktops. 
CodeReady Containers includes the crc command-line interface (CLI) to interact with the CodeReady Containers virtual machine running the OpenShift cluster.

# System Requirements
CodeReady Containers requires the following minimum hardware and operating system requirements.

## Hardware requirements
CodeReady Containers requires the following system resources:

* 4 virtual CPUs (vCPUs) 
* 8 GB of memory
* 35 GB of storage space

### Note: These requirements must be met in order to run OpenShift in the CodeReady Containers virtual machine. 

## Required software packages
CodeReady Containers requires the libvirt and NetworkManager packages. 

```
sudo apt install qemu-kvm libvirt-daemon libvirt-daemon-system network-manager
```


# Setup CRC Containers on Local 

Openshift comes with flavors and each has its specific usage. In order to learn, you can install Openshift locally with RedHat CodeReady Containers.

Earlier, minishift were used to install Openshift OKD which is open source version with Openshift 3.11.

For installing Openshift 4 locally, RedHat CodeRady Containers are made available, which you can use to to run.


# Install CodeReady Containers.

CodeRady Contaiiners, has single node configuraton and it operates exactly like Minishift.

CRC(CodeReay Containers) runs on native hypervisor, KVM for Linux, HyperKit for macOS, and Hyper-V for Windows. Following steps have been considered for Ubuntu.

## Installations.
VirtualBox is not supported so, KVM must be installed first.

### KVM Installation
Please perform following steps to install KVM, you can skip this step if you already have it.

```
$ sudo apt-get install qemu-kvm libvirt-bin virtinst bridge-utils cpu-checker
```
```
$ kvm-ok
```

### CRC Installation

RedHat has provided CRC installaton guide, to access this guide you need login into RedHat Account or Register for free.

The installation guide contains download link for CodeReady Containers for Linux, macOS, and Windows.

[CRC Installation Guide](https://cloud.redhat.com/openshift/install/crc/installer-provisioned)

The installation guide contains hardware requirements which can found below:

### Note: The crc binary should not be run as root (or Administrator). The crc binary should always be run with your user account.

Downloaf CodeReady Containers from archive and download the pull secret to local location.

Extract crc file and place it into /usr/local/bin/

Folow below commands to setup CodeReady Containers

```
$ crc setup
```

This will run the check for prerequisites, and create .crc directory.

Add the pull secret file paht which was downloaded from RedHat site. This pull secret will be used to download container images from the RedHat registry.

```
$ crc config set pull-secret-file path/to/pull-secret.txt
```

Initialize and start CodeReady Containers with following command

```
$ crc start
```
This takes a while, and once finish it will show instructions to access Openshift console.

Even after the start command finish it takes few more minutes to start, but you can still check its status

```
$ crc status
```

Now, once you get the status running you can actually acces openshift cluster using below command.

```
$ crc console
```
You can login with user kubeadin if you want to be cluster admin.

Below are some more commands you may need

```
$ crc stop
$ crc delete
```
