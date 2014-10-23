#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

: <<DOCUMENTATION
 -----------------------------------------------
| bokeh 
 -----------------------------------------------
A utility for installing Apache Blur to in a 
cloud cluster environment supporting testing.
 ----------------------------------------------
DOCUMENTATION

function usage { 
 echo "Usage: $0 -h" 
 exit 1 
}
scratch=$(mktemp -d -t tmp.XXXXXXXXXX)
function cleanup {
 rm -rf $scratch
}
trap cleanup EXIT

bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

set -e
set -u
set -o pipefail

IFS=$'\n\t'

EXPECTED_ARGS=":h"
set +u

while getopts "${EXPECTED_ARGS}" opt; do
  case $opt in 
     h)
       #TODO: Need some trimming here
       sed -n '/DOCUMENTATION$/,/^DOCUMENTATION/p' $0
       usage
      ;;
     \?)
      echo "Invalid option: -$OPTARG" >&2
      ;; 
     
   esac
done
set -u  

#___init
if [ ! -f ~/.bokeh ] ;then
  echo "Error: No properties found at ~/.bokeh" >&2
  exit 1
fi 

source ~/.bokeh

clientkey=$DO_CLIENT_KEY
clientid=$DO_CLIENT_ID

#___functions
function validate_keys {
 echo -n "Validating provider credentials... " >&2
 ( 
  cd ../libcloud
  python ./validate_creds.py -k "$1" -i "$2" > /dev/null 2>&1
 )  
  if [ "$?" != "0" ] ;then 
    echo "Error: Invalid login credentials" >&2
    exit 1
  fi
 echo " done." >&2
}

function generate_ssh_keys {
 echo -n "Generating cluster ssh keys... " >&2
 if [ -d ../../../target/.ssh ] ;then
   rm -Rf ../../../target/.ssh
 fi
 ./gen_keys.sh > /dev/null 2>&1
 echo " done." >&2
} 

function validate_packer {
  echo -n "Validating packer.io install... " >&2
  packer -v > /dev/null 
  echo " done." >&2
}

function build_blur_image {
  #Gah: hard code version for now
  packer build -var "do_client_id=$1" -var "do_api_key=$2" -var 'blur_version=apache-blur-0.2.4-incubating-SNAPSHOT-hadoop1' ../packer/blur-node.json
}

#___main

validate_keys $clientid $clientkey

generate_ssh_keys

validate_packer
echo "validating"
build_blur_image $clientkey $clientid
