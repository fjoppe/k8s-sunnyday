#!/bin/bash

workdir=$(pwd)
currentdir=`dirname -- "$( readlink -f -- "$0"; )";`

cd $currentdir/src

npm install
npm run build

cd $currentdir

docker build -t k8simage:database-latest - < ./Dockerfile

