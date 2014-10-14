#!/bin/bash

blur_home="$1"
sed -i -e "s/SSH_OPTS=/SSH_OPTS=\" -o StrictHostKeyChecking=no\"/" /srv/${blur_home}/conf/blur-env.sh
