set -x
set -e
pushd crc
make e2e PULL_SECRET_FILE=--pull-secret-file=~/crc-pull-secret BUNDLE_LOCATION=--bundle-location=''
make integration