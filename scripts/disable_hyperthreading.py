#!/usr/bin/env python3
from sys import argv

enable = False
disable = False
if 'disable' in argv[1:]:
    disable = True
elif 'enable' in argv[1:]:
    enable = True
elif 'status' in argv[1:]:
    pass
else:
    print('usage:', argv[0], 'enable|disable|status')
    print()
    print('Status:')

low, high = open('/sys/devices/system/cpu/present').read().split('-')
assert(low == '0')
vcpus = int(high) + 1
assert(vcpus % 2 == 0)

for i in range(0,vcpus//2):
    i += vcpus//2
    if disable or enable:
        with open(f'/sys/devices/system/cpu/cpu{i}/online', 'w') as f:
            f.write('0\n' if disable else '1\n')
    else:
        status = open(f'/sys/devices/system/cpu/cpu{i}/online', 'r').read().strip()
        print('vcpu', i, 'online' if status == '1' else 'offline')
