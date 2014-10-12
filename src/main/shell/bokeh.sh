#!/bin/bash

#### Arg validation
ARGS=2
COMMAND_NOT_FOUND=127

function usage {
 echo "Usage: $(basename $0) <clientid> <clientkey>"
}

if [ "$#" != "$ARGS" ] ;then
  usage
  exit 1
fi

clientkey=$1
clientid=$2

#### Function defs
function validate_keys {
 echo -n "Validating provider credentials... "
 ( 
  cd ../libcloud
  python ./validate_creds.py -k "$1" -i "$2" > /dev/null 2>&1
 )  
  if [ "$?" != "0" ] ;then 
    echo "Error: Invalid login credentials"
    exit 1
  fi
 echo " done."
}

function generate_ssh_keys {
 echo -n "Generating cluster ssh keys... "
 if [ -d ../../../target/.ssh ] ;then
   rm -Rf ../../../target/.ssh
 fi
 ./gen_keys.sh > /dev/null 2>&1
 echo " done."
} 

function validate_packer {
  echo -n "Validating packer.io install... "
  packer > /dev/null 2>&1
  if [ "$?" == "${COMMAND_NOT_FOUND}" ] ;then
    echo "Error: Packer.io is required and unfound."
    exit 1
  fi
  echo " done." 
}

function build_blur_image {
  #Gah: hard code version for now
  packer build -var "do_client_id=$1" -var "do_api_key=$2" -var 'blur_version=apache-blur-0.2.4-incubating-SNAPSHOT-hadoop1' ../packer/blur-node.json
}

#### Main

validate_keys $clientid $clientkey

generate_ssh_keys

validate_packer

build_blur_image $clientkey $clientid


