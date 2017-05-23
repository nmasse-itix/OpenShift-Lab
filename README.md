# OpenShift-Lab
This project is an Ansible Playbook to install OpenShift in a Lab Environment.

## Preparation work

1. Pull the "openshift-ansible" sub-project using :
```
git submodule init
git submodule update
```
2. Review \*.hosts and change hostnames to target your environment

## Example

```
./ansible bootstrap vm.openshift.test
./ansible play allinone
```


## Connection through a bastion host

Sometimes, your target machines are on a restricted network where access is
done through a "bastion host" (also called "jump host").

This section explains how to configure this project to work with such a
configuration.

Two variants of this configuration are possible :
 1. The jump host holds the SSH keys to connect to the target host
 2. The jump host has no SSH key, the SSH Keys remains on your machine

In the second configuration, you will have to setup your SSH Agent (if not
already done) and forward it.

### Step 1: Setup your SSH Agent (optional)

Run the SSH Agent :
```
eval "$(ssh-agent -s)"
```

And add your SSH key to your agent :
```
ssh-add ~/.ssh/id_rsa
```

Source : https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/

### Step 2: Create the ssh.cfg

Create a file named `ssh.cfg` with the following content :
```
Host jump.host
  Hostname jump.host
  User john-adm
  ForwardAgent yes
  ControlMaster auto
  ControlPath ~/.ssh/ansible-%r@%h:%p
  ControlPersist 5m

Host 10.0.0.*
  ProxyCommand ssh -q -W %h:%p jump.host
  User john
```

You will have to replace `jump.host` (three occurrences) with the hostname of your jump host.
Also make sure to that the two usernames match your environment :
- The first `User` stanza is the username you will use to connect to your jump host
- The second `User` stanza is the username you will use to connect to your target host

You will also have to replace `10.0.0.*` by the subnet of your target machines.
If you reference your machines by DNS names instead of IP address, you could use
the DNS suffix common to your target machines, like `*.compute.internal`.

Note: the `ForwardAgent` stanza is only required if your jump host does not hold
the SSH keys to connect to your target machines.

Now you can test your ssh.cfg by issuing the following command :
```
ssh -F ssh.cfg your.target.host
```
If your configuration is correct, you will be directly connected to your target
host.

### Step 3: Edit the Ansible configuration file

Edit the `ansible.cfg` file and add :
```
# Connection through a jump host
[ssh_connection]
ssh_args = -F ./ssh.cfg -o ControlMaster=auto -o ControlPersist=30m
control_path = ~/.ssh/ansible-%%r@%%h:%%p
```

You can test that your setup is correct by using the `ping` module of Ansible :
```
ansible -i your-inventory-file all -m ping
```

If your setup is correct, you should see something like :
```
machine1.internal | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
machine2.internal | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

Note: sometime your lab has no DNS server and you have to connect to your target
machines using IP addresses. If you still want to name your machines in Ansible
with a nice name, you can declare the target machines in the inventory file like this :
```
machine1.internal ansible_host=10.0.0.1
machine2.internal ansible_host=10.0.0.2
```
