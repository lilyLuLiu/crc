#!bin/bash
set -x
cat /etc/fedora-release
dnf install -y git libvirt libvirt-libs libvirt-devel gcc make
#libvirt-glib pkg-config
rpm -qa "*libvirt*"
curl --insecure -LO -C - https://go.dev/dl/go1.22.5.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
export CGO_ENABLED="1"
echo "${PULL_SECRET}" > ~/crc-pull-secret
cat ~/crc-pull-secret

