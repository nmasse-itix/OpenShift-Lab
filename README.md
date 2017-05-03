# OpenShift-Lab
This project is the Ansible Playbook to install OpenShift in a Lab Environment.

## Preparation work

1. Pull the "openshift-ansible" sub-project using `git submodule init && git submodule update` 
2. Review \*.hosts and change hostnames to target your Virtual Machines 

## Example

```
./ansible bootstrap vm.openshift.test
./ansible play allinone
```
