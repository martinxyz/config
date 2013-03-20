#!/usr/bin/env python
#
# Decode signal-tap CVS files exported by Quartus signal tap analyzer.
#
# This combines many bits into a hex stream. Signal tap analyzer will
# crash Quartus if you try to add a very long signal (say, 1200 bits)
# as a single signal, but adding all bits individually works.

import sys, csv

if len(sys.argv) != 2:
    print 'usage:', sys.argv[0], '<filename.csv>'
    sys.exit(1)

f = open(sys.argv[1])
line = ''
while not line.startswith('Data:'):
    line = f.readline()
    if not line:
        print 'File format not understood.'
        exit(1)

dr = csv.DictReader(f)
cur_name = None
cur_data = []
long2short = {}
for idx, row in enumerate(dr):
    print
    print idx
    res = {}
    d_value = {}
    d_idx   = {}
    for name in dr.fieldnames:
        value = row[name]

        if 'time unit: ' in name:
            continue

        if name not in long2short:
            # strip away as many '|' as possible
            name_long = name
            while '|' in name:
                name_short = name.split('|', 1)[-1] 
                conflicts = [True for s in dr.fieldnames if s.strip().endswith(name_short)]
                if len(conflicts) != 1:
                    break
                name = name_short
            long2short[name_long] = name
        else:
            name = long2short[name]

        if name.endswith(']'):
            name, idx = name.rsplit('[', 1)
            assert idx[-1] == ']'
            idx = idx[:-1]
        else:
            idx = None

        # strip whitespace
        name = name.strip()
        value = value.strip()
        if not name or not value: continue

        if cur_data and (name != cur_name or idx is None):
            # finish with cur_name, cur_data
            if len(cur_data) == 1:
                i, v = cur_data[0]
                if i:
                    print '%s[%s] = %s' % (cur_name, i, v)
                else:
                    print '%s = %s' % (cur_name, v)
            else:
                cur_data.sort(reverse=True)
                left  = cur_data[0][0]
                right = cur_data[-1][0]

                values = [v for i, v in cur_data]
                if len(values) % 8 == 0 and 'X' not in values:
                    i = int(''.join(values), 2) # base 2
                    values = ('%0' + str(len(values)/4) + 'X') % i
                else:
                    values = ''.join(values)

                print '%s[%s..%s] = %s' % (cur_name, left, right, values)
            cur_data = []
            cur_name = None

        if idx:
            # collect for later printing
            cur_name = name
            cur_data.append((idx, value))
        else:
            print '%s = %s' % (name, value)
            cur_name = None
            cur_data = []

