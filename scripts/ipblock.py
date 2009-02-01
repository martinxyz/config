#!/usr/bin/env python
import sys

def ip2str(ip):
    l = [
        (ip >> (3*8)) & 0xFF,
        (ip >> (2*8)) & 0xFF,
        (ip >> (1*8)) & 0xFF,
        (ip >> (0*8)) & 0xFF,
        ]
    return '.'.join([str(i) for i in l])

def str2ip(line):
    a, b, c, d = [int(s) for s in line.split('.')]
    ip = 0
    ip += (a << (3*8))
    ip += (b << (2*8))
    ip += (c << (1*8))
    ip += (d << (0*8))
    return ip


blockip = str2ip(sys.stdin.readline())
hostmask = 1
bitcount = 1

for line in sys.stdin.readlines():
    try:
        ip = str2ip(line.strip())
    except:
        print 'Ignored line:', line,
        continue
    while (blockip & (~hostmask)) != (ip & (~hostmask)):
        hostmask = (hostmask << 1) | 1
        bitcount += 1
    print ip2str(blockip & (~hostmask)) + '/' + str(bitcount),  'hostmask =', ip2str(hostmask)

print 'wrong way around'

