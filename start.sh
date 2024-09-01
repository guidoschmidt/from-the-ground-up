#!/usr/bin/env sh

### x86_64
qemu-system-x86_64 \
    -m 2048 \
    -smp 2 \
    -drive file=qemu/debian.amd64.qcow2,media=disk,if=virtio \
    -nic user,model=virtio \
    -virtfs local,path=/Users/gs/git/asm/ground-up,security_model=none,mount_tag=Project \
    -netdev "user,id=n1,hostfwd=tcp::2222-:22" \
    -nographic

### i386
# qemu-system-i386 \
#     -m 2048 \
#     -drive file=qemu/debian.i386.iso,media=disk,if=virtio \
#     -nic user,model=virtio \
#     -virtfs local,path=/Users/gs/git/asm/ground-up,security_model=none,mount_tag=Project \
#     -netdev "user,id=n1,hostfwd=tcp::2222-:22" \
#     -nographic
