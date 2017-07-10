# Sample partitioning

## Three disks partitions

This guide provides step-by-step instructions to help you partition your disks
for OpenShift.

It assumes you created a Virtual Machines with three disks :
 - `/dev/sda`: 10 GiB for the Operating System
 - `/dev/sdb`: 30 GiB for the OpenShift PVs
 - `/dev/sdc`: 50 GiB for the Docker Storage

`/dev/sda` is partitioned during installation. If possible, use LVM that will
give you greater flexibility if you need to extend that partition later.

Make sure to **NOT** allocate swap space since it is a [recommended best practice](https://docs.openshift.com/container-platform/3.5/admin_guide/overcommit.html#disabling-swap-memory).

After installation, you should have :
 - `/boot` backed by a primary partition, 512 MiB
 - `/` backed by a Volume Group named `rhel`, with a Physical Volume backed by a primary partition, 9.5 GiB
 - `/dev/sdb` and `/dev/sdc` are now empty

 ```
 $ sudo fdisk -l /dev/sda

Disk /dev/sda: 10.7 GB, 10737418240 bytes, 20971520 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x000a801b

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048     1050624     524288    83  Linux
/dev/sda2         1050625    20971519     9960447   8e  Linux LVM

$ sudo vgs
  VG      #PV #LV #SN Attr   VSize  VFree
  rhel      1   1   0 wz--n-  9.50g     0

$ sudo pvs
  PV         VG      Fmt  Attr PSize  PFree
  /dev/sda2  rhel    lvm2 a--   9.50g     0
```

__You can now partition `/dev/sdb` (OpenShift Persistent Volumes):__

<pre>
$ <b>sudo fdisk /dev/sdb </b>
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): <b>n</b>
Partition type:
   p   primary
   e   extended
Select (default p): <b>p</b>
Partition number (1,2,3,4, default 1): 1
First sector (2048-20971519, default 2048): <b>&lt;ENTER&gt;</b>
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2049-20971519, default 20971519): <b>&lt;ENTER&gt;</b>
Using default value 20971519
Partition 1 of type Linux and of size 30720 MiB is set

Command (m for help): <b>t</b>
Partition number (1, default 1): <b>1</b>
Hex code (type L to list all codes): <b>8e</b>
Changed type of partition 'Linux' to 'Linux LVM'

Command (m for help): <b>w</b>
The partition table has been altered!

Calling ioctl() to re-read partition table.

WARNING: Re-reading the partition table failed with error 16: Device or resource busy.
The kernel still uses the old table. The new table will be used at
the next reboot or after you run partprobe(8) or kpartx(8)
Syncing disks.
</pre>

Create a Volume Group and add the new partition:
```
sudo vgcreate storage /dev/sdb1
```

Create a new Logical Volume:
```
sudo lvcreate storage -n openshift -l %FREE
```

Format it:
```
sudo mkfs.xfs /dev/mapper/storage-openshift
```

Create an entry in `/etc/fstab`:
```
sudo -i
echo "/dev/mapper/storage-openshift /var/openshift xfs defaults 0 0" >> /etc/fstab
```

Finalize the setup:
```
sudo mkdir /var/openshift
sudo mount /var/openshift
sudo chmod 777 -R /var/openshift
sudo chcon -Rt svirt_sandix_file_t /var/openshift
```

__You can now partition `/dev/sdc` (Docker Storage):__

<pre>
$ <b>sudo fdisk /dev/sdc </b>
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): <b>n</b>
Partition type:
   p   primary
   e   extended
Select (default p): <b>p</b>
Partition number (1,2,3,4, default 1): 1
First sector (2048-20971519, default 2048): <b>&lt;ENTER&gt;</b>
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2049-20971519, default 20971519): <b>&lt;ENTER&gt;</b>
Using default value 20971519
Partition 1 of type Linux and of size 51200 MiB is set

Command (m for help): <b>t</b>
Partition number (1, default 1): <b>1</b>
Hex code (type L to list all codes): <b>8e</b>
Changed type of partition 'Linux' to 'Linux LVM'

Command (m for help): <b>w</b>
The partition table has been altered!

Calling ioctl() to re-read partition table.

WARNING: Re-reading the partition table failed with error 16: Device or resource busy.
The kernel still uses the old table. The new table will be used at
the next reboot or after you run partprobe(8) or kpartx(8)
Syncing disks.
</pre>

Create a Volume Group and add the new partition:
```
sudo vgcreate docker /dev/sdc1
```

And that's it ! :)
