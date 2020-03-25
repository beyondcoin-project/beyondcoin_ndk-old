#! /bin/bash
set -xeo pipefail

DOCKERHASH=6603364284e4fe27f973e6d2e42b7eacf418baabf87b89638d46453772652d2e
DOCKERIMAGE=greenaddress/core_builder_for_android@sha256:$DOCKERHASH
docker pull $DOCKERIMAGE

ARCHS="armv7a-linux-androideabi=32 aarch64-linux-android=64 x86_64-linux-android=64 i686-linux-android=32"

build_repo() {
    for TARGETHOST in $ARCHS; do
        docker run -v $PWD:/repo $DOCKERIMAGE /bin/bash -c "/repo/fetchbuild.sh $1 $2 $3 $4 $5 ${TARGETHOST/=/ }" &
    done
}

build_repo https://github.com/beyondcoin-project/beyondcoin.git ebdf68e6410fc419079dba7014ae75aa46ff2e36 beyondcoin beyondcoin --disable-man

wait

echo "DONE"

printpackages() {
    echo
    for f in $(find . -type f -name "*$1.tar.xz" | sort)
    do
        shahash=$(sha256sum $f | cut -d" " -f1)
        filesize=$(ls -lat $f | cut -d" " -f5)
        arch=${f/.\//}
        arch=${arch/$1.tar.xz/}
        echo \"${filesize}${arch}${shahash}\",
    done
    echo
}

set +x
printpackages _beyondcoin
