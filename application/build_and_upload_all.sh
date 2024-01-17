#!/bin/bash

currentscriptdir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

$currentscriptdir/database/build.sh

$currentscriptdir/restapi/build.sh
