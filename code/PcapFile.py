"""
pcap file format library
2010-01 ZHAW, Martin Renold
2010-02 ZHAW, David Gunzinger
public domain
"""

import struct

class PcapFile:

    def __init__(self, filename, mode='r', nanoseconds=False):
        self.mode = mode
        if mode == 'r':
            self.f = file(filename,'rb')
            self.__read_header()
        elif mode == 'w':
            self.nanoseconds = nanoseconds
            self.f = file(filename, 'wb')
            self.__write_header()
        else:
            raise NotImplementedError, 'mode not supported, must be r or w'
        self.pktnr = 1
        
        
    def __write_header(self):
        if self.mode != 'w':
            raise NotImplementedError, 'can only write header in w mode'
        if self.nanoseconds:
            magic = 0xa1b23c4d
        else:
            magic = 0xa1b2c3d4
        data = struct.pack('IHHiIII',
                   magic, # guint32 magic_number;   /* magic number */
                   2, # guint16 version_major;  /* major version number */
                   4, # guint16 version_minor;  /* minor version number */
                   0, # gint32  thiszone;       /* GMT to local correction */
                   0, # guint32 sigfigs;        /* accuracy of timestamps */
                   65535, # guint32 snaplen;        /* max length of captured packets, in octets */
                   1, # guint32 network;        /* data link type */
                   )
        self.f.write(data)

    def __read_header(self):
        if self.mode != 'r':
            raise NotImplementedError, 'can only read header in r mode'     
        header = self.f.read(24)
        header_unpack=struct.unpack('IHHiIII',header)
        #self.header = header_unpack
        if (header_unpack[0] == 0xa1b23c4d):    # PCAP_NSEC_MAGIC
            self.nanoseconds = True
        elif(header_unpack[0] == 0xa1b2c3d4):
            self.nanoseconds = False
        else:
            raise NotImplementedError("header magic %x not yet implemented"%(header_unpack[0],))
        
    
    def get_mode(self):
        """
        returns the mode of the class: r for reading, w for writing
        """
        return self.mode
  
    def get_nanoseconds(self):
        """
        returns if ts_subsec is nanoseconds or seconds
        """
        return self.nanoseconds
        
    def get_packetnr(self):
        """
        returns the packetnr
        """
        return self.pktnr
        
        
    def write_frame(self, data, ts_sec=0, ts_subsec=0):
        """
        ts_subsec is in usec by default. If the file was opened with nanoseconds=True, it is in nanoseconds.
        """
        data = struct.pack('IIII', 
                           ts_sec, # guint32 ts_sec;         /* timestamp seconds */
                           ts_subsec, # guint32 ts_usec;        /* timestamp <s>microseconds</s>sub seconds */
                           len(data), # guint32 incl_len;       /* number of octets of packet saved in file */
                           len(data), # guint32 orig_len;       /* actual length of packet */
                           ) + data
        self.f.write(data)
        self.pktnr+=1
  
    def read_frame(self):
        """
        ts_subsec is in usec by default. If the file was opened with nanoseconds=True, it is in nanoseconds.
        """
        header = self.f.read(16)
        if(len(header) != 16):
            raise EOFError()
        header_unpack = struct.unpack("IIII",header)
        hdr = {"ts_sec":header_unpack[0],
        "ts_subsec":header_unpack[1],
        "incl_len":header_unpack[2],
        "orig_len":header_unpack[3],
        "nr":self.pktnr}
        self.pktnr+=1
        data = self.f.read(hdr["incl_len"])
        if(len(data) != hdr['incl_len']):
            raise EOFError()        
        return (hdr,data)

    def __iter__(self):
        while 1:
            try:
                yield self.read_frame()
            except EOFError:
                return

    def close(self):
        self.f.close()


def open(*args, **kwargs):
    return PcapFile(*args, **kwargs)

if __name__ == '__main__':
    import unittest
    class PcapTestCase(unittest.TestCase):
        def testPcap(self):
            self.filename = "test.pcap"
            self.nanoseconds = False
            self.testdata = "123qwe"
            self.write()
            self.read()
        def testPcapNS(self):
            self.filename = "testNS.pcap"
            self.nanoseconds = True
            self.testdata = "123qwe"
            self.write()
            self.read()
        
        def write(self):
            f = PcapFile(self.filename, 'w',self.nanoseconds)
            assert f.get_packetnr() == 1, 'incorrect packet nr at writing'
            f.write_frame(self.testdata,ts_sec=1,ts_subsec=100)
            assert f.get_packetnr() == 2, 'incorrect packet nr at writing'
            f.write_frame(self.testdata,ts_sec=2,ts_subsec=300)
            assert f.get_packetnr() == 3, 'incorrect packet nr at writing'

        def read(self):
            # write done, do reading
            f = PcapFile(self.filename,'r',self.nanoseconds)
            assert f.get_packetnr() == 1, 'incorrect packet nr at reading'
            
            (hdr,data) = f.read_frame()
            assert f.get_packetnr() == 2, 'incorrect packet nr at reading'
            
            assert data == self.testdata, 'incorrect data read'
            assert hdr['ts_sec'] == 1, 'incorrect second timestamp' 
            assert hdr['ts_subsec'] == 100, 'incorrect subsecond timestamp'
            assert hdr['incl_len'] == len(data), 'incorrect saved data len' 
            assert hdr['orig_len'] == len(data), 'incorrect original data len' 
            assert hdr['nr'] == 1 , 'incorrect packetnr in hdr'
            
            (hdr,data) = f.read_frame()
            assert f.get_packetnr() == 3, 'incorrect packet nr at reading'
            
            assert data == self.testdata, 'incorrect data read'
            assert hdr['ts_sec'] == 2, 'incorrect second timestamp' 
            assert hdr['ts_subsec'] == 300, 'incorrect subsecond timestamp'
            assert hdr['incl_len'] == len(data), 'incorrect saved data len' 
            assert hdr['orig_len'] == len(data), 'incorrect original data len' 
            try:
                (hdr,data) = f.read_frame()
            except EOFError:
                pass
            else:
                fail("expected a EOFError")

                
    suite = unittest.makeSuite(PcapTestCase,'test')
    runner = unittest.TextTestRunner()
    runner.run(suite)


