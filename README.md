blur-perf
=========

A scratchpad to explore testing blur in a cluster environment.

Overview
=========
The goal is for the project to contain two types of capability: 1) Some tooling for creating dynamic clusters in the cloud - standing up and tearing down; and 2) Some tooling for measuring performance at scale including querying, incremental indexing, etc.  Well, that's the goal anyway...

Cluster Tooling
=========
The current idea is to create images with Packer.io and create the instances with libcloud.  

To create the ssh keys:
```
 cd src/main/scripts
 ./gen_keys.sh
```
To create an image with Blur installed:
```
packer build -var 'do_client_id=your_digital_ocean_id_here' \
   -var 'do_api_key=your_digital_ocean_key_here' \
   -var 'blur_version=apache-blur-0.2.4-incubating-SNAPSHOT-hadoop1' \
   blur-node.json
```

To startup the image with libcloud:
```
 python libcloudtest.py -k your_digital_ocean_key_here -i your_digital_ocean_clientid_here
```

Perf Test Tooling
=========
TBD.


Note
=========
Everything is executed as individual commands for now.  Once we know exactly how we want to
orchestrate things we'll wrap it with a proper driver script.
