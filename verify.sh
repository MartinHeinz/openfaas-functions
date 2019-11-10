#!/bin/bash
set -e

CLI="faas-cli"
suffix=$3

if ! [ -x "$(command -v faas-cli)" ]; then
    HERE=`pwd`
    cd /tmp/
    curl -sSL https://cli.openfaas.com | sh
    CLI="/tmp/faas-cli"

    cd $HERE
fi

for yaml in ./*.yml
do
    echo $yaml

    pushd . 2>/dev/null 1>&2
    $CLI build -f $yaml
    popd 2>/dev/null 1>&2
done
