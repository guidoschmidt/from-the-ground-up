# Qemu

Download Debian image
```
curl -Lo debian.qcow2 \
    https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-nocloud-amd64.qcow2
```

Resize to desired disk size
```
qemu-img resize debian.qcow2 16G
```

Run the machine
```
./start.sh
```

guest `/etc/fstab`:
```
Project /root/ground-up 9p _netdev,trans=virtio,version=9p2000.u,msize=104857600 0 0
```

Exit the virtual machine
```
Crtl-A x
```

Login: `root`


---
### Sources
- [1] https://gist.github.com/gsf/c7bb24178700ffcaeab9c100c63264bb
