#!/bin/sh

etc_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd)"
FWUART=`cd $etc_dir/.. ; pwd`
export FWUART

# Add a path to the simscripts directory
export PATH=$FWUART/packages/simscripts/bin:$PATH

# Force the PACKAGES_DIR
export PACKAGES_DIR=$FWUART/packages

