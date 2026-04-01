#!/bin/bash

set -o errexit
set -o pipefail

CONTAINER_TOOL=docker
if command -v podmand &>/dev/null; then
    CONTAINER_TOOL=podman
fi

if [[ $# -eq 0 ]]; then
    echo "missing arguments" >&2
    echo "usage: $(basename "$0") IMAGE [TARGET]"
    exit 1
fi

IMAGE=${1?missing image}

if [[ ${TRACE-0} == "1" ]]; then
    set -o xtrace
fi

if [[ -n $2 ]]; then
    if [[ ! -d $2 ]]; then
        mkdir "$2"
    fi
    ROOTFS_DIR=$2
else
    ROOTFS_DIR=$(mktemp -d)
fi

CONTAINER_ID=$($CONTAINER_TOOL create "$IMAGE")
trap 'docker rm $CONTAINER_ID' EXIT
$CONTAINER_TOOL export "$CONTAINER_ID" | tar -xC "$ROOTFS_DIR"
