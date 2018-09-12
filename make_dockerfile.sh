#!/bin/bash

function usage() { 
    echo "usage: make_dockerfile.sh GIT_BRANCH"
}

if test "${1:-}" = ""; then
    usage
    exit 1
fi

export BRANCH_NAME=${1}

wget -q -O /dev/null "http://metwork-framework.org/pub/metwork/continuous_integration/rpms/${BRANCH_NAME}/centos7/repodata/repomd.xml"
if test $? -ne 0; then
    echo "Forcing branch to master"
    export BRANCH_NAME=master
fi

cat Dockerfile.template |envtpl >Dockerfile
