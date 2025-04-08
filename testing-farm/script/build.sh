#source prepare.sh
set -x
set -e
CRC_SCM="https://github.com/code-ready/crc.git"
LIBVIRT_DRIVER_SCM="https://github.com/code-ready/machine-driver-libvirt.git"
ADMINHELPER_SCM="https://github.com/code-ready/admin-helper.git"
git clone $CRC_SCM

git clone $LIBVIRT_DRIVER_SCM
pushd machine-driver-libvirt
mdl_version_line=$(cat pkg/libvirt/constants.go | grep DriverVersion)
mdl_version=${mdl_version_line##*=} 
mdl_version=$(echo $mdl_version | xargs)
go build -v -o crc-driver-libvirt-local ./cmd/machine-driver-libvirt
popd

git clone $ADMINHELPER_SCM
admin_version_line=$(cat admin-helper/crc-admin-helper.spec.in | grep Version:)
admin_version=${admin_version_line##*:} 
admin_version=$(echo $admin_version | xargs)
make -C admin-helper out/linux-amd64/crc-admin-helper VERSION=$admin_version 

pushd crc
mkdir -p custom_embedded
cp ./../machine-driver-libvirt/crc-driver-libvirt-local custom_embedded/crc-driver-libvirt-amd64
cp ./../admin-helper/out/linux-amd64/crc-admin-helper custom_embedded/crc-admin-helper-linux-amd64
# Match admin-helper version with latest from master head
sed -i "s/crcAdminHelperVersion.*=.*/crcAdminHelperVersion = \"${admin_version}\"\n/g" pkg/crc/version/version.go
# Match machine-driver-libvirt version with latest from master head
sed -i "s/MachineDriverVersion =.*/MachineDriverVersion = \"${mdl_version}\"/g" pkg/crc/machine/libvirt/constants.go
make linux-release CUSTOM_EMBED=true EMBED_DOWNLOAD_DIR=custom_embedded
popd

# Download crc installer, first parmater is the install url
#curl --insecure -LO -C - ${1} 
#sudo tar xvf crc-linux-amd64.tar.xz --strip-components 1 -C /usr/local/bin/
#crc version
#rm crc-linux-amd64.tar.xz
ls crc/release

tar xvf crc/release/crc-linux-amd64.tar.xz --strip-components 1 -C /usr/local/bin/
crc version