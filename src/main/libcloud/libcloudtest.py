#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
from libcloud.compute.types import Provider
from libcloud.compute.providers import get_driver
import time
import libcloud.security
import sys, getopt
libcloud.security.CA_CERTS_PATH = ['ca-bundle.cer']


def main(argv):
	clientid = ''
	clientkey = ''
	packerimg = ''
	try:
		opts, args = getopt.getopt(argv,"hi:k:p:",["clientid=","clientkey=","packerimg="])
	except getopt.GetoptError:
		print 'blurcloud.py -k <clientkey> -i <clientid> -p <packerimg>'
		sys.exit(2)
	for opt, arg in opts:
		if opt == '-h':
			print 'blurcloud.py -k <clientkey> -i <clientid> -p <packerimg>'
			sys.exit()
		elif opt in ("-i", "--clientid"):
			clientid = arg
		elif opt in ("-k", "--clientkey"):
			clientkey = arg
		elif opt in ("-p", "--packerimg"):
			packerimg = arg
	
	DIGITALOCEAN_USER = clientid
	DIGITALOCEAN_KEY = clientkey
	PACK_IMG = packerimg
	Driver = get_driver(Provider.DIGITAL_OCEAN)
	conn = Driver(DIGITALOCEAN_USER, DIGITALOCEAN_KEY)

	sizes = conn.list_sizes()
	images = conn.list_images()
	locations = conn.list_locations()
	size = [s for s in sizes if s.name == '512MB'][0]
 
	image = [i for i in images if i.name == PACK_IMG][0]
	print('Using image[' + image.name + ']')
	location = [l for l in locations if l.name == 'New York 2'][0]
	node = conn.create_node(name='libcloud', size=size, image=image, location=location)
	#print(node)
	#print("Now sleeping...")
	#time.sleep(120)
	#print("Ok., now we'll kill it.")
	#conn.destroy_node(node)


def print_locations(conn):
	print("Locations: ")
	print(conn.list_locations())

#print(locations)
#print(sizes)
#keys = conn.create_ssh_key()
#print(conn.ex_list_ssh_keys())
#size = [s for s in sizes if s.name == '512MB'][0]
#print('Using size[' +size.name + ']')
#location = [l for l in locations if l.name == 'New York 2'][0]
#print(node)
#print("Now sleeping...")
#time.sleep(120)
#print("Ok., now we'll kill it.")
#conn.destroy_node(node)

if __name__ == "__main__":
	main(sys.argv[1:])
