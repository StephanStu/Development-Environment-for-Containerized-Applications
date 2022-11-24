# Development-Environment-for-Containerized-Applications
This repository holds infrastructure as code that spins up a virtual development environment for containerized applications.
The virtual environment is a virtual machine running in virtual box. The machine is defined by a Vagrantfile; to distribute the environment, only this file is needed. The most important advantage of using Vagrant is that it can be ported to any operating system - so everyone will have the same environment independent of his or her host system (MacOs, Windows, some Linux-Distribution).

The following is automatically deployed and ready to used once the machine is ready:
* k3s: Boostrapped Kubernetes Cluster ready to host containers
* pip: Installing packages for Python
* forwarded port(s) for applications
* forwarded port(s) for cluster operations

The following is planned:
* KAFKA: Messsage broker for event-based message-passing
* ARGO-CD: Continuous Deployment Framework


## Deployment of the Virtual Machine with Vagrant
After installing dependencies, ensure [Vagrant](https://www.vagrantup.com/) is ready on your machine by running
```console
vagrant version
```
In this directory, run
```console
vagrant up
```
in order to let Vagrant follow the instructions contained in the Vagrantfile. This may take some time. At some point the command line output should be
```console
'==> default: Machine booted and ready!'
```
Then, verify, that your machine is ready by running
```console
vagrant status
```
This command should return *running*. Furthermore, a '.vagrant'-folder has been created in this directory. You must also be able to see the machine in [VirtualBox](https://www.virtualbox.org/wiki/Downloads). We can ssh into the machine now by from the console
```console
vagrant ssh
```
This commands automatically identifies the box and ssh's into it because all necessary information is kept in the '.vagrant'-folder.

## Stoping and Deleting the Virtual Machine
If your Vagrant box is still running, make sure it is shutdown by running
```console
vagrant halt
```
To destroy the machine, run
```console
vagrant destroy
```
or (if you receive an error)
```console
vagrant destroy -f
```
More commands on backup and restore of the machine with Vagrant can be found [here](https://www.webfoobar.com/node/52).

## Dependencies
This project depends on the following solutions:+
* [Vagrant](https://www.vagrantup.com/) defines an image that runs the development environment.
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads) is needed to run the image, that is created with Vagrant.
* [K3S](https://k3s.io/), the Kubernetes distribution that runs the containers.

## Cheatsheet for Vagrant and k3s
This section is today on the 'go.sh' and needs clean up.
