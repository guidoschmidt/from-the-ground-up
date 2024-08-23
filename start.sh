#!/usr/bin/env sh
qemu-system-x86_64 \
    -m 2048 \
    -smp 2 \
    -drive file=qemu/debian.qcow2,media=disk,if=virtio \
    -nic user,model=virtio \
    -virtfs local,path=/Users/gs/git/asm/ground-up,security_model=none,mount_tag=Downloads \
    -netdev "user,id=n1,hostfwd=tcp::2222-:22" \
    -nographic
