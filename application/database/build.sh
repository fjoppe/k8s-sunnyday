#!/bin/bash

export workdir=$(pwd)
export currentdir=`dirname -- "$( readlink -f -- "$0"; )";`
ls $currentdir

cd $currentdir/src

npm install
npm run build

cd $currentdir

docker build -t k8simage:database-latest .
