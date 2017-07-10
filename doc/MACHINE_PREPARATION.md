# Preparation of target machines

Currently, the machines needs to have at least 2 disk partitions :
 - 1 partition for the Operating System (**REQUIRED**)
 - 1 LVM partition for the Docker Storage (**REQUIRED**)

A third partition is recommended but not required :
 - 1 partition for the OpenShift Persistent Volumes (**OPTIONAL**),

Minimal requirements :
 - the Docker Storage partition has to be at least 50 GiB
 - the OpenShift Persistent Volumes partition has to be at least 30 GiB (**OPTIONAL**)
 - the Operating System partition has to be at least 10 GiB if you have a dedicated
   partition for OpenShift PVs, 40 GiB otherwise.

If your machine has only one disk, you can create partitions (that may use LVM underneath or not, free choice).
An alternative when using Virtual Machines is to add 3 disks to the VM, the setup is a bit easier.

The OS partition is created by the RHEL installer so you do not have to care much about it.

The Docker Storage partition **has to be LVM** and **has to be in a separate Volume Group**.
Namely, if your Docker Storage partition is `/dev/sda2`, you can create a separate Volume Group by using :
```
vgcreate docker /dev/sda2
```

The OpenShift Persistent Volumes partition, if not required is still highly recommended.
By a having a dedicated partition, if the Persistent Volumes start to grow it will not
fill up the OS partition.

If your OpenShift PV partition is `/dev/sda3`, you can set it up by using :
```
mkfs.xfs /dev/sda3
echo "/dev/sda3 /var/openshift xfs defaults 0 0" >> /etc/fstab
```

If you kept the default values (`docker` for the Volume Group name and
`/var/openshift` for the OpenShift PV mount point), no further setup is required.

Otherwise, you might have to set the following variables in your inventory file :
 - `docker_storage_vg`
 - `hostpath_provisioner_options`

See the [Sample Partitioning Guide](SAMPLE_PARTITIONING.md) for a step-by-step guide on how to prepare
partitions for OpenShift.
