#!/usr/bin/env python3
import hidapi
import struct
import time

#devices = list(hidapi.enumerate())
d = hidapi.Device(vendor_id=0x4d9, product_id=0xa052)

# thanks to https://github.com/patrislav1/zytemp_mqtt
d.send_feature_report(b'\xc4\xc6\xc0\x92\x40\x23\xdc\x96', b'\0')
while True:
    data = d.read(8)
    checksum = sum(data[:3]) & 0xff
    if checksum != data[3]:
        continue
    cmd, value = struct.unpack('>bh', data[:3])
    if cmd == 0x50:
        print(f'CO2: {value} ppm')
    elif cmd == 0x42:
        value = value / 16 - 273.15
        #print(f'Temp: {value:.1f} C')
    else:
        pass
        #print(data.hex(), value)

