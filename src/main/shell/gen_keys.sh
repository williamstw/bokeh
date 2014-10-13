#!/bin/bash
 
{
cd ../../../target
mkdir -p ./.ssh
cd .ssh
echo -n "Creating keys..."
ssh-keygen -t rsa -P '' -f id_rsa
cat id_rsa.pub > authorized_keys
echo "done."
}
