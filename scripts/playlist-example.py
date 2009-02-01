#!/usr/bin/env python
from mplaylists import *
import random

pool = ReadDirectory('/mp3')

playlist   = pool[:] # copy (pool will be used for user selections)
sleep      = TakeSongs(playlist, '(night|sleep)') # take out of the main playlist
preferred  = CopySongs(playlist, 'beatles') # just copy (it's a regex, btw.)

preferred += ReadPlaylist('/playlists/new150')

webradios = '''
http://dradio-live.ogg.t-bn.de/dkultur_high.ogg # Deutschlandradio Kultur
http://dradio-live.ogg.t-bn.de/dlf_high.ogg # Deutschlandfunk
'''

pool += webradios.split('\n') # only pool: never choose automatically

class MySongSelector(SongSelector):
    def select(self):
        if self.userrequest and random.randrange(3) != 0:
            self.log('Random choice.')
            return self.myrandom()
        else:
            self.log('Similar choice.')
            return self.similar(playlist)

    def myrandom(self):
        if random.randrange(10) == 1:
            return self.random(preferred)
        else:
            return self.random(playlist)

Main(pool, MySongSelector())
