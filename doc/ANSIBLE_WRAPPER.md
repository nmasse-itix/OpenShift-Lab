# Ansible Wrapper presentation

The Ansible Wrapper is a small shell script (`./ansible`) that does two things :
 - It calls the bootstrap playbook with the right environment variables
 - It calls the target playbooks (`allinone.yml` for instance) with the right inventory file

## Bootstrap

Usually, when machines are provisioned, they are not ready to be used in Ansible.
For example :
 - There is no regular user account, `root` is the only available user
 - You SSH Keys are not yet installed, so a Password Authentication is required
 - Sudo might no be configured
 - etc.

The ansible wrapper will :
 - Make sure the SSH Host Key of the target machine is trusted (otherwise Ansible would complain...)
 - Do a password authentication for the first time (thanks to `sshpass`)
 - Add your SSH Keys to the `authorized_keys`
 - Create a regular user (by default: `redhat`)
 - Install and configure sudo
 - Register the machine with the Red Hat Network (RHN)
 - Attach a subscription pool

To use the wrapper, you need to make sure you have `sshpass` installed :
```
sshpass -V
```

If not installed, setup sshpass as explained here : https://gist.github.com/arunoda/7790979

To bootstrap a machine, just use :
```
./ansible bootstrap machine1.compute.internal
```

__Tip :__ You can pass multiple machine on the command line to bootstrap them all at the same time.

The wrapper, will then ask you a few questions :
 - The root password. If you have already setup SSK Key Authentication, you can just hit enter.
 - Your RHN login
 - Your RHN password
 - The Pool ID that you would like to use. If you do not provide a Pool ID, no pool will be attached and you will have to do it later manually.

## Daily usage

Once your machines are bootstrapped, you can launch the target playbook (`allinone` for instance) with :
```
./ansible play allinone
```

__Note :__ the `play` command is just a shortcut to `ansible-playbook -i <target>.host <target>.yml`
