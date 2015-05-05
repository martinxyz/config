#!/usr/bin/env python
# file created 2010-07, Martin Renold, InES, ZHAW
"""
Check whether HSR, PRP-0, PRP-1 or Ping sequence numbers are increasing
without gaps, and print diagnostic information about it.
"""
import pcap
import sys, os, time, optparse

parser = optparse.OptionParser(
    usage = '%prog <network_interface|pcap_filename>',
    description = __doc__.lstrip()
    )
parser.add_option('-n', '--seqno', type='int', default=1000, metavar='N', help='print sequence numbers that are a multiple of this value (default: 1000)')
parser.add_option('-w', '--window', type='int', default=0, metavar='N', help='frames to tolerate from a single source until a sequence number is reported missing (default: 0)')
parser.add_option('-i', '--ignore', type='string', default=0, metavar='MAC1,MAC2,...', help='list of sources to ignore')
parser.add_option('-v', '--verbose', action="store_true", default=False, help="verbose (report supervision frames, show content of non-hsr/non-prp frames)")
parser.add_option('-q', '--quiet', action="store_true", default=False, help="quiet output. Nothing is displayed except the statistic is displayed at the end")
parser.add_option('-l', '--interfaces', action="store_true", default=False, help="list all network interfaces reported by libpcap")
parser.add_option('-p', '--disable-prp', action="store_true", default=False, help="disable prp, and only capture headers, not the full frame")
parser.add_option('-a', '--node-forget-time', type="float", metavar='SECONDS', default=30.0, help="idle time after which we forget all previos sequence numbers; 0.0=never")

options, args = parser.parse_args()

if options.interfaces:
    print 'Interfaces available for capturing:'
    for x in pcap.findalldevs():
        print x[0], ':', x[1:]
    sys.exit(0)

if len(args) != 1:
    parser.print_help()
    sys.exit(1)

ignore_macs = []
if options.ignore:
    ignore_macs = options.ignore.split(',')

devnull = open(os.devnull, "w")
error = sys.stderr
info = sys.stdout    # general info
info_pp = sys.stdout    # info per packet
verbose = devnull

if options.verbose:
    verbose = sys.stdout
elif options.quiet:
    info = devnull
    info_pp = devnull

dev = sys.argv[1]
#net, mask = pcap.lookupnet(dev)

p = pcap.pcapObject()
if os.path.isfile(dev):
    is_file = True
    p.open_offline(dev)
else:
    is_file = False
    if options.disable_prp:
        snaplen = 120 # enough for headers, and icmp payload
    else:
        snaplen = 1800
    p.open_live(dev,
                snaplen,
                True, # promisc
                100   # timeout ms (wait for accumulating several packets at once)
                )
    #p.setnonblock(1)

mac2str_cache = {}
def bytes2hex(bytes, sep=' '):
    return sep.join(['%02X' % ord(c) for c in bytes])
def mac2str(mac):
    # optimized :-)
    res = mac2str_cache.get(mac, None)
    if not res:
        res = bytes2hex(mac, sep=':')
        mac2str_cache[mac] = res
    return res

class Stream:
    def __init__(self, stream_name):
        self.frames = 0
        self.duplicates = 0
        self.seqno_errors = 0
        self.missing_errors = 0
        self.stream_name = stream_name
        self.correct_since_last_error = 0
        self.time_last_seen = None
        self.forget()

    def forget(self):
        # forget previous sequence numbers (but keep statistics)
        self.seqno_expected = None
        self.window = []
        self.duplicate_window = []

    def seen(self, seqno, timestamp):
        self.frames += 1

        if self.time_last_seen:
            idle = timestamp - self.time_last_seen
            if idle >= options.node_forget_time:
                print >>info_pp, self.stream_name, 'was idle for %.2f seconds; reset' % idle
                self.forget()
        self.time_last_seen = timestamp

        if self.seqno_expected is None:
            self.seqno_expected = (seqno+1)&0xffff
            print >>info_pp, self.stream_name, 'First seqno:', seqno
            self.duplicate_window.append(seqno)
            return

        if seqno in self.duplicate_window:
            print >>info_pp, self.stream_name, 'Duplicate:', seqno
            self.duplicates += 1
            return

        if seqno % options.seqno == 0:
            print >>info_pp, self.stream_name, 'Seqno:', seqno

        self.duplicate_window.append(seqno)
        self.duplicate_window = self.duplicate_window[-100:] # keep the last 100, no matter what seqno

        # check for an unexpected frames (eg. duplicates for which we didn't see the original)
        # (This is to avoid reporting a huuuge gap in the sequence numbers.)
        if ((seqno - (self.seqno_expected-1))&0xffff) > 4*options.window+1000:
            print >>info_pp, self.stream_name, 'Out of order:', seqno, '(%d expected; after %d correct numbers; reset)' % (self.seqno_expected, self.correct_since_last_error),
            if self.window:
                print >>info_pp, '(ignored %d other frames)' % len(self.window)
            else:
                print >>info_pp
            self.window = []
            self.seqno_expected = (seqno+1)&0xffff
            self.seqno_errors += 1
            self.correct_since_last_error = 0
            return
        else:
            self.window.append(seqno)

        # find missing frames
        missing = []
        while len(self.window) > options.window or self.seqno_expected in self.window:
            if self.seqno_expected in self.window:
                self.window.remove(self.seqno_expected)
                if not missing:
                    self.correct_since_last_error += 1
            else:
                missing.append(self.seqno_expected)
            self.seqno_expected = (self.seqno_expected+1)&0xffff

        if missing:
            print >>info_pp, self.stream_name, 'Missing:', missing[0],
            if len(missing) > 1:
                print >>info_pp, '-', missing[-1],
            print >>info_pp, '(%d missing after %d correct numbers)' % (len(missing), self.correct_since_last_error)
            self.missing_errors += 1
            self.correct_since_last_error = 0


hsr_nodes = {}
prp0_nodes = {}
prp1_nodes = {}
pings = {}
frames = 0
def analyze(pktlen, data, timestamp):
    global frames
    data_orig = data
    if len(data) < 60:
        print >>error, 'Error: Undersized frame of length %d! (Maybe TX from this computer?)' % len(data)
        data += (60-len(data))*chr(0)
    dst = data[0:6]
    src = data[6:12]
    macstr = mac2str(src)
    if macstr in ignore_macs:
        return
    frames += 1
    ethertype = bytes2hex(data[12:14], sep='')

    hsr_prp_present = False

    # VLAN
    if ethertype == '8100':
        data = data[0:12] + data[16:]
    
    ethertype = bytes2hex(data[12:14], sep='')
    # HSR    
    if ethertype == '892F':
        hsr_prp_present = True
        if src not in hsr_nodes:
            print >>info, macstr, 'New HSR Node'
            hsr_nodes[src] = Stream(macstr)

        node = hsr_nodes[src]
        seqno = ord(data[16])*256 + ord(data[17])
        node.seen(seqno, timestamp)
        ethertype = bytes2hex(data[18:20], sep='')
        data = data[:12] + data[18:] 

    # HSR/PRP supervision (TODO print output does not apply for PRP supervision frames)
    if ethertype == '88FB':
        print >>verbose, macstr, 'supervision'

    if not options.disable_prp:
        if len(data_orig) != pktlen:
            print >>error, 'Frame was shortened while capturing. Frame size %d, capture size %d.' % (pktlen, len(data_orig))
            print >>error, 'Cannot check for PRP trailer. Try --disable-prp.'
            sys.exit(1)
        # PRP-0 trailer
        trailer = data[-4:]
        lsdu_size = ((ord(trailer[-2]) & 0x0F) << 8) + ord(trailer[-1])
        lan_id = (ord(trailer[-2]) & 0xF0) >> 4
        if lsdu_size == len(data)-14 and lan_id in (0xA, 0xB):
            hsr_prp_present = True
            link = mac2str(src) + " -> " + mac2str(dst) + " LAN " + '%X' % lan_id
            if link not in prp0_nodes:
                print >>info, link, 'New PRP-0 Node'
                prp0_nodes[link] = Stream(link)

            node = prp0_nodes[link]
            seq_nr = ord(trailer[0])*256 + ord(trailer[1])
            node.seen(seq_nr, timestamp)
            data = data[:-4]	# remove PRP-0 trailer

        # PRP-1 trailer
        if data[-2:] == '\x88\xFB':
            hsr_prp_present = True
            trailer = data[-6:-2]
            lsdu_size = ((ord(trailer[-2]) & 0x0F) << 8) + ord(trailer[-1])
            lan_id = (ord(trailer[-2]) & 0xF0) >> 4
            if lan_id in (0xA, 0xB):
                if lsdu_size != len(data)-14:
                    print >>error, 'Warning: ignoring PRP-1 trailer with lsdu_size=%d (expected %d)' % (lsdu_size, len(data)-14)
                else:
                    if src not in prp1_nodes:
                        print >>info, macstr, 'New PRP-1 Node'
                        prp1_nodes[src] = Stream(macstr)

                    node = prp1_nodes[src]
                    seq_nr = ord(trailer[0])*256 + ord(trailer[1])
                    node.seen(seq_nr, timestamp)
                    data = data[:-6]	# remove PRP-1 trailer

    # Ping (ICMP Request / Reply)
    if ethertype == '0800': # IP
        if data[0x17] == chr(1): # ICMP
            ping = None
            if data[0x22] == chr(0):
                ping = 'REPLY'
            elif data[0x22] == chr(8):
                ping = 'REQUEST'
            if ping:
                ping_id = bytes2hex(data[0x26:0x28], sep='')
                stream = '%s_PING_%s_%s' % (macstr, ping, ping_id)
                if stream not in pings:
                    print >>info, stream, 'New Stream'
                    pings[stream] = Stream(stream)
                if 'abcdefghijklm' in data:
                    # Windows ping. Little endian sequence number.
                    ping_seqno = ord(data[0x29])*256 + ord(data[0x28])
                else:
                    # Linux ping. Big endian sequence number.
                    ping_seqno = ord(data[0x28])*256 + ord(data[0x29])
                pings[stream].seen(ping_seqno, timestamp)

    if not hsr_prp_present:
        print >>verbose, macstr, 'non-hsr/prp frame with ethertype', ethertype
        print >>verbose, macstr, 'frame content:\n', bytes2hex(data_orig)

    #print timestamp % 60, pktlen
    # 100ms

try:
    while 1:
        res = p.dispatch(1, analyze)
        if is_file and res == 0:
            break
        received, dropped, dropped2  = p.stats()
        if dropped or dropped2:
            print >>error, 'ERROR: Interface has dropped frames! %d and %d frames dropped.' % (dropped, dropped2)
            print >>error, '       Your CPU is probably too slow to catch up with this traffic.'
            print >>error, '       (You can record a pcap instead, and analyze it later with this tool.)'
            sys.exit(1)

        #if res != 0:
        #    print res
except KeyboardInterrupt:
    pass

print
print '--- final statistic --'
print frames, 'total frames received'

def printstats(node):
    print node.stream_name, ':', node.frames, 'frames;', node.seqno_errors, 'frames out of sequence;', node.duplicates, 'duplicates;', node.missing_errors, 'missing errors'

for proto, nodes in [('HSR', hsr_nodes), ('PRP-0', prp0_nodes), ('PRP-1', prp1_nodes)]:
    if nodes:
        print '--- %s statistic --' % proto
        print len(nodes), '%s sources' % proto
        nodes = nodes.values()
        nodes.sort(key=lambda node: node.stream_name)
        for node in nodes:
            print node.stream_name, ':', node.frames, 'frames;', node.seqno_errors, 'frames out of sequence;', node.duplicates, 'duplicates;', node.missing_errors, 'missing errors'






