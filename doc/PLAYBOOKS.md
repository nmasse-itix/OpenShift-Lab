# Playbooks description

## Bootstrap (`bootstrap.yml`)

The bootstrap playbook is used to prepare a machine to be managed by Ansible.
Namely, it will :
 - Create a regular user account (named `redhat`)
 - Add your SSH Public Key to the `authorized_keys` of `root` and `redhat`
 - Install and configure `sudo` so that the `redhat` user can launch commands as `root` without password
 - Register the machine on the RHN (Red Hat Network)

To work, this playbook will require a few environment variables :

| Environment Variable | Description |
| --- | --- |
| RHN_LOGIN | Your Red Hat Network login |
| RHN_PASSWORD | Your Red Hat Network password |
| RHN_POOLID | The subscription pool you want to use |

__Tip :__ You can get the PoolID by querying :
```
sudo subscription-manager list --available --matches '*OpenShift*'
```

This playbook is best used with the [Ansible Wrapper](ANSIBLE_WRAPPER.md).

## All-in-one cluster (`allinone.yml`)

The All-in-one cluster playbook will deploy everyting on one machine. It is very
convenient for development or PoC where the focus is on the features rather than on the infrastructure.

Minimal requirements for the target machine are :
 - 2 Cores
 - 4 GB of RAM
 - 30 GB Hard Disk, partitioned as explained in the [Machine Preparation Guide](MACHINE_PREPARATION.md)

Recommended config :
 - 4 Cores
 - 10 GB of RAM
 - 60 GB Hard Disk, partitioned as explained in the [Machine Preparation Guide](MACHINE_PREPARATION.md)

See [Machine Preparation Guide](MACHINE_PREPARATION.md) for more details about partitioning.

## Small cluster (TODO)

TODO

## Big cluster (TODO)

TODO
