#!/bin/bash -e

my_dir=`dirname $0`

. $my_dir/config

if [ ! -e packages/helloclear ]; then
	echo Please build helloclear first
	exit 1
fi

[ -e clear.img ] || ( curl -o clear.img.xz $MIRROR/image/clear-$(curl $MIRROR/latest)-kvm.img.xz && unxz -v clear.img.xz )
[ -e OVMF.fd ] || curl -O $MIRROR/image/OVMF.fd 
if [ ! -e start_qemu.sh ]; then
	curl -O $MIRROR/image/start_qemu.sh
	if [ ! -e /dev/kvm ]; then
		sed -i -e "s/-enable-kvm//g" -e "s/-cpu host/-cpu Haswell/g" -e "s/-smp sockets=.,cpus=.,cores=./-smp sockets=1,cpus=`nproc`,cores=`nproc`/g" start_qemu.sh
	fi
	chmod +x start_qemu.sh
fi

cd packages/helloclear
make install
cd -

echo "run qemu: sudo ./start_qemu.sh clear.img"
