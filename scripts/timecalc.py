#!/usr/bin/env python
"""Simple work-time calculator.

Enter time expressions in the form "07:30-10:54 + 13:15-18:15"
(python preprocessor replacing HH:MM-HH:MM with hours as float)

Examples:

09:30-12:00 + 13:10-17:06
6.43 hours (6h 25min)

09.30-12.00/13.10-17.06  # numpad friendly syntax
6.43 hours (6h 25min)

0.8*( 09.30-12.00/13.10-17.06 )
5.15 hours (5h 8min)

3*3+1 # use as calculator
10

---
"""

import time

class Hours2(float):
    def __init__(self, value):
        if type(value) is str:
            start, stop = value.split('-')
            start = parsetime(start)
            stop = parsetime(stop)
            #raise ValueError, 'Bad time expression: ' + value
            self.value = stop - start
        else:
            self.value = float(value)
    def __add__(self, other):
        try:
            return Hours(self.value + float(other))
        except:
            return Hours(self.value + other.value)
    def __mul__(self, other):
        try:
            return Hours(self.value * float(other))
        except:
            return Hours(self.value * other.value)
    __radd__ = __add__
    __rmul__ = __mul__
    def __str__(self):
        t = self.value
        days = int(t / 24.0)
        hours = int(t - days*24.0)
        minutes = int((t - days*24.0 - hours) * 60.0)
        s = str(minutes) + 'min)'
        if hours: s = str(hours) + 'h ' + s
        if days: s = str(days) + 'd ' + s
        s = '%.2f hours (' % (t) + s
        return s
        
class Hours:
    def __init__(self, value):
        if type(value) is str:
            start, stop = value.split('-')
            start = parsetime(start)
            stop = parsetime(stop)
            #raise ValueError, 'Bad time expression: ' + value
            self.value = stop - start
        else:
            self.value = float(value)
    def __add__(self, other):
        try:
            return Hours(self.value + float(other))
        except:
            return Hours(self.value + other.value)
    def __mul__(self, other):
        try:
            return Hours(self.value * float(other))
        except:
            return Hours(self.value * other.value)
    __radd__ = __add__
    __rmul__ = __mul__
    def __str__(self):
        t = self.value
        days = int(t / 24.0)
        hours = int(t - days*24.0)
        minutes = int((t - days*24.0 - hours) * 60.0)
        s = str(minutes) + 'min)'
        if hours: s = str(hours) + 'h ' + s
        if days: s = str(days) + 'd ' + s
        s = '%.2f hours (' % (t) + s
        return s
        
def parsetime(s):
    "returns absolute time in hours (float)"
    s = s.replace(':', '.')
    return time.mktime(time.strptime(s + '.2000', '%H.%M.%Y')) / (60.0*60.0)

def process_line(line):
    line = line.replace('/', ' + ')
    s = ''
    for part in line.split():
        if part.count(':')+part.count('.') == 2 and part.count('-') == 1:
            part = 'Hours("' + part + '")'
        s += part + ' '
    return s

def test():
    print Hours('12:33-13:11')
    print 5 + Hours('12:33-13:11')
    print Hours('12:33-13:11') + 5
    print 90 * Hours('12:33-13:11')


if __name__ == '__main__':
    import sys
    if len(sys.argv) == 1:
        print __doc__
        userscope = {'Hours':Hours}
        while 1:
            line = sys.stdin.readline()
            if not line: sys.exit(0)
            s = process_line(line)
            try:
                exec '_result_ = ' + s in userscope
            except KeyboardInterrupt:
                break
            except Exception, e:
                userscope['_result_'] = 'ERROR: ' + str(e)
            print userscope['_result_']
            print
    else:
        TODO
        """
        for filename in sys.argv[1:]:
            print 'processing', filename, 'to', filename + '.py'
            f = open(filename + '.py', 'w')
            f.write('#!/usr/bin/env python\n')
            f.write('from timecalc.py import time2str')
            for line in open(filename).readlines():
        """

