# Programming From The Ground Up

---
## Setup
### Qemu

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

On the virtual machine guest, add virtual drive via:
```
vim /etc/fstab
```
then add the following line
```
Project /root/ground-up 9p _netdev,trans=virtio,version=9p2000.u,msize=104857600 0 0
```

Exit the virtual machine
```
Crtl-A x
```

Login: `root`


---

## Sources
- [0] https://archive.org/details/programming-from-the-ground-up
- [1] https://gist.github.com/gsf/c7bb24178700ffcaeab9c100c63264bb
- [2] https://blachniet.com/posts/create-a-minimal-local-debian-vm-with-qemu/
