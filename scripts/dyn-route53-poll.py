#!/usr/bin/env python
#
# Daemon script polling the network interface IP address and updating
# AWS route53 record on change.

#
# configuration
#
ip_interface = 'eth0'
hostname = '.log2.ch' # need leading . for toplevel update
ttl = 60
aws_credentials = '/home/martin/.aws_credentials.csv'

junk, aws_access_key_id, aws_secret_access_key = \
    open(aws_credentials).readlines()[1].strip().split(',')


import sys, re, time
import boto
#from boto.route53.exception import DNSServerError
from boto.route53.record import ResourceRecordSets

# stolen from https://github.com/goura/dynamic53/blob/master/dynamic53/app.py
def r53_change_record(name, values,
                      aws_access_key_id, aws_secret_access_key,
                      proxy=None, proxy_port=None,
                      type="A", ttl="600", comment=""):

    # note: if the network is unreachable this function will retry,
    #       blocking up to one minute before the last retry (not configurable?)
    conn = boto.connect_route53(aws_access_key_id=aws_access_key_id,
                                aws_secret_access_key=aws_secret_access_key,
                                proxy=proxy,
                                proxy_port=proxy_port
                                )
    res = conn.get_all_hosted_zones()

    domain_name = re.sub('^[^\.]*\.', '', name)
    if name[0] == '.':
        name = name[1:]

    hosted_zone_id = None
    for zoneinfo in res['ListHostedZonesResponse']['HostedZones']:
        zonename = zoneinfo['Name']
        _zone_id = zoneinfo['Id']
        _zone_id = re.sub('/hostedzone/', '', _zone_id)
        if zonename[-1] == '.':
            zonename = zonename[:-1]

	#print domain_name, zonename
	if domain_name == zonename:
	    hosted_zone_id = _zone_id
            break

    if not hosted_zone_id:
        raise RuntimeError, 'domain_name ' + repr(domain_name) + ' not found in hosted zones'

    changes = ResourceRecordSets(conn, hosted_zone_id, comment)
    
    response = conn.get_all_rrsets(hosted_zone_id, type, name, maxitems=1)
    if response:
        rrset = response[0]
        change1 = changes.add_change("DELETE", name, type, rrset.ttl)
        for old_value in rrset.resource_records:
            change1.add_value(old_value)
    change2 = changes.add_change("CREATE", name, type, ttl)
    for new_value in values.split(','):
        change2.add_value(new_value)
    return changes.commit()

# from http://stackoverflow.com/a/9267833/235548
import socket, struct, fcntl
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sockfd = sock.fileno()
SIOCGIFADDR = 0x8915
def get_ip(iface = 'eth0'):
    ifreq = struct.pack('16sH14s', iface, socket.AF_INET, '\x00'*14)
    try:
        res = fcntl.ioctl(sockfd, SIOCGIFADDR, ifreq)
    except:
        return None
    ip = struct.unpack('16sH2x4s8x', res)[2]
    return socket.inet_ntoa(ip)


oldip = None
while True:
    myip = get_ip(ip_interface)
    #print 'myip', myip
    if myip != oldip:
        print 'IP change from', oldip, 'to', myip
        if myip is not None and myip != '0.0.0.0':
            print 'updating DNS record...'
            try:
                if r53_change_record(hostname, myip, aws_access_key_id, aws_secret_access_key, ttl=ttl):
                    oldip = myip
                    print 'success.'
                else:
                    print 'updating failed.'
            except KeyboardInterrupt:
                raise
            except Exception, e:
                print 'updating failed!'
                print 'exception:', e

    time.sleep(30)
