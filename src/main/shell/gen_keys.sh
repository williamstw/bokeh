#!/bin/bash

{
cd ../../../target
mkdir -p ./.ssh
cd .ssh
echo -n "Creating keys..."
ssh-keygen -t rsa -P '' -f id_dsa
cat id_dsa.pub > authorized_keys
echo "done."
}
