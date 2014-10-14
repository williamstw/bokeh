bokeh
=========

A scratchpad to explore testing blur in a cluster environment.

Overview
=========
The goal is for the project to contain two types of capability: 1) Some tooling for creating dynamic clusters in the cloud - standing up and tearing down; and 2) Some tooling for measuring performance at scale including querying, incremental indexing, etc.  Well, that's the goal anyway...

Cluster Tooling
=========
The current idea is to create images with [Packer.io](http://www.packer.io/) and create the instances with [libcloud](http://libcloud.apache.org/).  

Create an image with ssh keys installed:
```
 cd src/main/shell/
 ./bokeh.sh <digital_ocean_client_id> <digital_ocean_client_key>
 ```
At the very end of the output you'll find the packerid to be used to start up the droplets below, e.g 'packer-1413245058' below:

```
==> Builds finished. The artifacts of successful builds are:
--> digitalocean: A snapshot was created: 'packer-1413245058' in region 'New York 2'
```

You can find your API credentials by logging into digital ocean and going here [https://cloud.digitalocean.com/api_access].

Note: The project is designed to create an ephemeral cluster to support testing, so it overwrites previous ssh 
      ssh keys in the ./target directory.  If you have previous images you want to continue to use, you'll need
      to manually mv that .ssh directory out of target.

To startup the image with libcloud:
```
 cd src/main/libcloud
 python libcloudtest.py -k your_digital_ocean_key_here -i your_digital_ocean_clientid_here -p <packer_image_name>
```

For debugging, to ssh to your droplet:
```
ssh -i ../../../target/.ssh/id_rsa -l blur -o "StrictHostKeyChecking no" blur@<ip_addr> free
```

I've found [Tugboat](https://github.com/pearkes/tugboat) essential for goofing around with this stuff too.  For example, to get the IP address of your new droplet:

```
tugboat droplets | grep libcloud
```

TODO 
========
- [ ] Change droplet creation to prefix/suffix all droplets with a test id (e.g. timestamp)
- [ ] Create the running droplet from the bokeh script
- [ ] Install full Hadoop stack on Blur image
- [ ] Either create a separate image for ZK or figure out a subset (e.g. first 3) to install quorum on.
- [ ] Gather all test IPs and generate shards/controllers files and push them up
- [ ] Gather ZK IPs and push updates to blur-site.properties
- [ ] ?Make one instance publicly addressable and the rest on private IPs?
- [ ] ...

Perf Test Tooling
=========
TBD.


Note
=========
Everything is executed as individual commands for now.  Once we know exactly how we want to
orchestrate things we'll wrap it with a proper driver script.
