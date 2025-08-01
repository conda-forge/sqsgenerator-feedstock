#!/bin/bash
set -ex

TARGET_PLATFORM=$SUBDIR

if [[ "${TARGET_PLATFORM}" == "linux-aarch64" ]]; then
    export VCPKG_TARGET_TRIPLET="arm64-linux"
    export CMAKE_ARGS="-DVCPKG_TARGET_TRIPLET=${VCPKG_TARGET_TRIPLET} -DCMAKE_MAKE_PROGRAM=Ninja ${CMAKE_ARGS}"
elif [[ "${TARGET_PLATFORM}" == "linux-ppc64le" ]]; then
    export VCPKG_TARGET_TRIPLET="ppc64le-linux"
    export CMAKE_ARGS="-DVCPKG_TARGET_TRIPLET=${VCPKG_TARGET_TRIPLET} -DCMAKE_MAKE_PROGRAM=Ninja ${CMAKE_ARGS}"
elif [[ "${TARGET_PLATFORM}" == "osx-arm64" ]]; then
    export VCPKG_TARGET_TRIPLET="arm64-osx"
    export CMAKE_ARGS="-DVCPKG_TARGET_TRIPLET=${VCPKG_TARGET_TRIPLET} ${CMAKE_ARGS}"
elif [[ "${TARGET_PLATFORM}" == "osx-64" ]]; then
   export VCPKG_TARGET_TRIPLET="x64-osx"
   export CMAKE_ARGS="-DVCPKG_TARGET_TRIPLET=${VCPKG_TARGET_TRIPLET} ${CMAKE_ARGS}"
fi

git clone https://github.com/microsoft/vcpkg.git
vcpkg/bootstrap-vcpkg.sh

export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"

echo "Platform ${TARGET_PLATFORM} -> ${VCPKG_TARGET_TRIPLET}"

$PYTHON -m build -w -n -x python/

$PYTHON -m pip install python/dist/sqsgenerator*.whl