# On the server

## 1. Setup local mount points

Create permanent mount points for the disk used for sharing, so that
we can more easily use a bind mount for the NFS version

**/etc/fstab**
```
# <file system>					<mount point>		<type>	<options>		<dump>	<pass>

UUID=d18a3097-a928-41e8-a3ed-4cf1a69fdb3b	/media/the-library	btrfs	defaults,nofail		0	2
UUID=c68aae58-ecd6-4aa3-a3c9-656b9a6e7043	/media/archives		btrfs	defaults,nofail		0	2
```

## 2. Setup file-sharing user to squash incoming logins

```
sudo adduser --uid=33300 fileshare
sudo adduser rick fileshare
```

## 3. Setup permissions on the mounts appropriately

Create NFS bind mounts:

**/etc/fstab**
```
/media/the-library/TheStacks                    /srv/nfs/TheStacks      none    bind,nofail		0       2
/media/the-library/Nooks/Ricky                  /srv/nfs/RickyNook      none    bind,nofail		0       2
/media/the-library/Nooks/Raine                  /srv/nfs/RaineNook      none    bind,nofail		0       2
```

## 4. Fixup permissions for changed files

NFS doesn't have great support for preserving attributes when we
squash users, so use the sticky bit on the directory to ensure that
incoming files are set appropriately.

**shell**
```
# Update owner
chown -R rick /media/the-library/Nooks/Ricky/
chmod -R raine /media/the-library/Nooks/Raine/

# Update groups
chgrp -R fileshare /media/the-library/Nooks/
chmod -R g+wx  /media/the-library/Nooks/

# Set sticky bit: Always use these permissions!
chmod -R +s /media/the-library/TheStacks/
```

## 5. Setup NFS Itself

### Install NFS

```
sudo apt install nfs-kernel-server
```


### Setup Export Directories

```
mkdir -p /srv/nfs{RickyNook,RaineNook}
```

### Setup NFS Settings

Note that the `insecure` option is required for all mounts accessible via macOS

**/etc/exports**
```
# MUST INCLUDE INSECURE IN THE OPTIONS FOR REMOTE MACOS MOUNTS

#
# RickyNook exports
#
# 501 is Rick's uid on THIS machine
/srv/nfs/RickyNook 10.0.0.0/24(rw,all_squash,anonuid=501,anongid=33300,insecure,no_subtree_check) \
                   *.local    (rw,all_squash,anonuid=501,anongid=33300,insecure,no_subtree_check) \
                   192.168.0.3(rw,all_squash,anonuid=501,anongid=33300,insecure,no_subtree_check)


#
# RaineNook exports
#
# 1003 is Raine's uid on THIS machine
/srv/nfs/RaineNook      10.0.0.0/24(rw,all_squash,anonuid=1003,anongid=33300,insecure,no_subtree_check)
/srv/nfs/RaineNook      *.local    (rw,all_squash,anonuid=1003,anongid=33300,insecure,no_subtree_check)
```
