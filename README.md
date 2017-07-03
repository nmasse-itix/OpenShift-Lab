# An "easy to use" OpenShift Lab
This project is an Ansible Playbook to install OpenShift in a Lab Environment.

Its goal is to help people install easily OpenShift in a lab environment,
for a test drive or a PoC. So, this project focuses mostly on ease of use instead
of security, availability, etc. **DO NOT USE THIS PROJECT IN PRODUCTION**.
You have been warned.

It features multiple architecture choices :
 - All-in-one: master, etcd, infra node, app node on the same machines (**DONE**)
 - Small Cluster: 1 master with etcd, 1 infra node, 2 app nodes (**TODO**)
 - Big Cluster: 3 masters with etcd, 2 infra nodes, 2 app nodes, 1 load balancer (**TODO**)

By default, it deploys the following software in addition to OpenShift :
 - Red Hat SSO
 - 3scale
 - the [OpenShift-Hostpath-Provisioner](https://github.com/nmasse-itix/OpenShift-HostPath-Provisioner)

This project is different from existing "demo" OpenShift playbooks in the sense that :
 - It features a common inventory file for both the OpenShift playbooks and the complimentary playbooks. (it's easier to maintain)
 - The underlying openshift-ansible playbooks are included directly (as opposed to other approaches that run an `ansible-playbook` command from inside the main playbook).

By default, this project comes with a git submodule reference to the `openshift-ansible` repository for convenience.
But you could replace this reference with a symlink to your `openshift-ansible` installation, for instance if you installed the supported package from Red Hat.

## Requirements

- This playbook starts from a minimal RHEL 7.3 installation. 
- You need at least a free disk partition to hold the docker storage (try to allocate at least 50Gi)
- You will need at least 30Gi free disk space on /var

The docker storage partition needs to be added to `docker` Volume Group. 
To do so, if your docker storage partition is /dev/sda3, run : 
```
vgcreate docker /dev/sda3
```

## Setup

1. First of all, clone this repo :
```
git clone https://github.com/nmasse-itix/OpenShift-Lab.git
```

2. Pull the "openshift-ansible" sub-project using :
```
git submodule init
git submodule update
```
3. Review allinone.hosts and change hostnames to target your environment

4. If needed, bootstrap your machines (optional) :
```
./ansible bootstrap vm.openshift.test
```

5. Run the playbook that installs everything on one machine :
```
./ansible play allinone
```

## Further readings

If you plan to use this project regularly, you might have a look at the [Ansible roles description](doc/ROLES.md).
And if you need to customize this project to suit your own needs, have a look at the [Customization Guide](doc/CUSTOMIZATION.md).
