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
	packimg = 'packer-1413053219'
	try:
		opts, args = getopt.getopt(argv,"hi:k:p",["clientid=","clientkey=","packerimg="])
	except getopt.GetoptError:
		print 'blurcloud.py -k <clientkey> -i <clientid> -p <packerimg>'
		sys.exit(2)
	for opt, arg in opts:
		if opt == '-h':
			print 'blurcloud.py -k <clientkey> -i <clientid> -p <packerimg>'
			sys.exit()
		elif opt in ("-i", "--clientid"):
			clientid = arg
		elif opt in ("-p", "--packerimg"):
			packimg = arg
		elif opt in ("-k", "--clientkey"):
			clientkey = arg

	DIGITALOCEAN_USER = clientid
	DIGITALOCEAN_KEY = clientkey
	PACK_IMG = packimg
	Driver = get_driver(Provider.DIGITAL_OCEAN)
	conn = Driver(DIGITALOCEAN_USER, DIGITALOCEAN_KEY)

	sizes = conn.list_sizes()

def print_locations(conn):
	print("Locations: ")
	print(conn.list_locations())

if __name__ == "__main__":
	main(sys.argv[1:])
