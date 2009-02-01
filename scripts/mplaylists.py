#!/usr/bin/env python
"""
Music playlist server controlling mplayer as backend.
See playlist-example.py to find out how to use it.
"""
mplayer_path = '/usr/bin/mplayer'
# playlog = None
playlog_path = '/home/martin/sich/playlog'
playlog = open(playlog_path, 'a')

import os, sys, random, re, time
stdout = sys.stdout

### Helper functions, they all return a list of filenames

def ReadDirectory(dir):
    "returns a list of filenames in the directory, with dir prefix"
    result = []
    for filename in os.listdir(dir):
        result.append(os.path.join(dir, filename))
    result.sort()
    return result
def ReadPlaylist(filename):
    "returns a list of filenames (maybe you'll need to make them absolute paths)"
    result = []
    for line in open(filename).readlines():
        line = line.split('#')[0].strip()
        if line: result.append(line)
    return result
    
def CopySongs(playlist, regexp = None, remove=False):
    "returns a list of the strings matching regexp, without removing them from playlist"
    if not regexp and not remove: return playlist[:]
    result = []
    regexp = regexp.replace(' ', '.*') # "easy" regexps
    regexp = re.compile(regexp, re.IGNORECASE)
    for filename in playlist[:]:
        if regexp.search(filename):
            if remove: playlist.remove(filename)
            result.append(filename)
    return result
def TakeSongs(playlist, regexp):
    "returns a list of the strings matching regexp and removes them from playlist"
    return CopySongs(playlist, regexp, remove=True)

def CopyRare(playlist, percent=25):
    "copy the least played X percent of the given playlist"
    count = {}
    for name in playlist:
        count[name] = 0
    for line in open(playlog_path):
        name = line.split(' ', 1)[1][:-1]
        if name not in count: continue
        count[name] += 1

    l = [(count, name) for (name, count) in count.items()]
    l.sort()
    i = len(l) * percent / 100
    return [name for count, name in l[:i]]


### Fuzzy string matching

def filename_words(filename):
    s = filename.split('/')[-1]
    words = re.findall(r'[a-zA-Z]+', s)
    return [w.lower() for w in words]

def filename_similarity(s1, s2):
    w1 = filename_words(s1)
    w2 = filename_words(s2)
    score = 0
    while w1 and w2:
        if w1[0] == w2[0]:
            score += 10 + len(w1[0])
            w1.pop(0)
            w2.pop(0)
        else:
            break
    for w in w1:
        if w in w2:
            score += len(w)
    return score

### Stock song selection code

class SongSelector:
    def __init__(self):
        pass

    def __call__(self, history, userrequest, output):
        self.history = history
        self.userrequest = userrequest
        self.output = output
        return self.select()
    
    def log(self, s):
        self.output.write(s + '\n')

    def select(self):
        raise NotImplemented, 'abstract method'

    def random(self, playlist):
        for i in range(20):
            song = random.choice(playlist)
            if song not in self.history:
                break
        return song

    def similar(self, playlist):
        if not self.history:
            return self.random(playlist)
        prev = self.history[-1]

        try:
            next = playlist[playlist.index(prev) + 1]
        except ValueError, IndexError:
            next = self.random(playlist)

        if next in self.history:
            next = self.random(playlist)

        next_score = filename_similarity(prev, next)
        print 'next', next, 'score', next_score
        better = []

        sample_size = len(playlist)/10
        if sample_size < 100:
            sample_size = len(playlist)

        for candidate in random.sample(playlist, sample_size):
            if candidate in self.history:
                continue
            score = filename_similarity(prev, candidate)
            if score > next_score:
                better.append(candidate)
    
        print 'better:', len(better)
        print '\n'.join(better)
        if better:
            if random.randrange(5) == 0:
                print 'Choosing random anyway.'
                next = self.random(playlist)
            else:
                print 'Chossing a better one.'
                next = random.choice(better)
        return next

### Select what to play next

history = []
future = []
last_button_t = time.time()

def NextSong(f, userrequest):
    global future, history, last_button_t 
    if future:
        filename = future.pop(0)
        f.write('From the stack: (%d items left now)\n' % (len(future)))
    else:
        filename = User_selectSongFunc(history, userrequest, f)
        assert filename
    if playlog and history:
        t = time.time()
        dt = t - last_button_t
        if userrequest:
            playlog.write('AFTER %.3f SKIP ' % dt + history[-1] + '\n')
        else:
            playlog.write('AFTER %.3f DONE ' % dt + history[-1] + '\n')
        #playlog.flush()
        last_button_t = t
    f.write(os.path.basename(filename).replace('_', ' ') + '\n')
    history.append(filename)
    return filename.split(' # ')[0] # remove "comment" keywords

def PrevSong(f = stdout):
    global future, history
    if len(history) < 2:
        return ''
    # the current one is already in the history
    filename = history.pop()
    future.insert(0, filename)
    # the previous one

    filename = history[-1]
    f.write(os.path.basename(filename).replace('_', ' ') + '\n')
    return filename

def Command(command, f = stdout):
    global future, history
    # interpret as song selection string
    info = None
    if not command:
        future = []
        f.write('Stack cleaned.\n')
    else:
        arg = command[1:].strip()
        arg_regexp = arg.replace(' ', '.*') # "easy" regexps
        command = command[0]
        if command == '-':
            taken = TakeSongs(future, arg_regexp)
            info = 'Removed %d songs from the stack.' % (len(taken))
        if command == 'm' and future:
            future = []
            mplayer.stop()
        if (command == 'm' and arg) or command == '+':
            added = CopySongs(User_pool, arg_regexp)
            info = 'Added %d songs to the stack.' % (len(added))
            future += added
            if added: 
                if command == 'm': mplayer.stop()
                random.shuffle(future)
        if command == '=':
            added = CopySongs(User_pool, arg_regexp)
            added.sort()
            info = 'Appended %d songs to the stack.' % (len(added))
            future = future + added
        if command == '>':
            added = CopySongs(User_pool, arg_regexp)
            random.shuffle(added)
            info = 'Inserted %d songs to the stack.' % (len(added))
            future = added + future

    if future:
        f.write('--- Stack ---\n')
        if len(future) > 100:
            f.write('[not listing %d files]\n' % len(future))
        else:
            f.write('\n'.join(future) + '\n')
        f.write('--- End of Stack ---\n')
    else:
        f.write('Stack is empty.\n')
    if info: f.write(info + '\n')

### Events, mplayer backend and other twisted stuff

from twisted.internet import reactor, stdio, protocol
from twisted.protocols import basic

help = """Commands:
h              display this help text
[empty line]   play next song
n              play next song and show stack
p              previous song
s              stop/pause
q              quit
i              info (filename being played)
k              kill (end server)
m foo bar      replace stack with songs matching 'foo.*bar' (random order)
m              wipe out the stack (return to normal playback mode)
+ foo bar      add those songs to the stack and reshuffle it
+              add all songs to the stack
- foo bar      remove those songs from the stack
> foo bar      insert those songs, in random order, on top of the stack
= al bum       append those songs, sorted by name, to the stack
rm             remove current song from disk (the one printed by 'i')
"""

class Prompt(basic.LineReceiver):
    from os import linesep as delimiter
    def connectionMade(self):
        self.sendLine('(enter h for help)')
    def lineReceived(self, line):
        global mplayer
        line = line.strip()
        if not line or line.strip() == 'n':
            if mplayer.paused:
                mplayer.pause()
                self.sendLine('[continued]')
            else:
                mplayer.stop()
                play(NextSong(f=self.transport, userrequest=True))
        elif line == 'h' or line == '?':
            self.sendLine(help)
        elif line == 's':
            if mplayer.paused:
                mplayer.stop()
                mplayer = mplayer_stopped
                PrevSong()
                self.sendLine('[stopped]')
            elif mplayer.stopped:
                self.sendLine('Already stopped!')
            else:
                mplayer.pause()
                self.sendLine('[paused]')
        elif line == 'i':
            if not history:
                print "Nothing, waiting for your first command"
            else:
                self.sendLine(history[-1])
        elif line == 'rm':
            if not history:
                print "Nothing to remove."
            else:
                try:
                    os.remove(history[-1])
                    #del history[-1]
                except OSError:
                    self.sendLine('cannot remove ' + history[-1])
                else:
                    self.sendLine('removed ' + history[-1])
            self.lineReceived('n')
        elif line == 'p':
            mplayer.stop()
            play(PrevSong(self.transport))
        elif line == 'q' or line == 'k':
            if self is commandline or line == 'k':
                mplayer.stop()
                mplayer = mplayer_stopped
                reactor.stop()
            else:
                self.transport.loseConnection()
        else:
            Command(line.strip(), self.transport)

class Mplayer(protocol.ProcessProtocol):
    stopped = False
    def __init__(self):
        self.paused = False
    def connectionMade(self):
        #print "Mplayer process started."
        pass
    def outReceived(self, data):
        #print data,
        #if data.startswith('A:'):
        #    self.pos = data
        pass
    def errReceived(self, data):
        #print "errReceived! with %d bytes!" % len(data)
        #print data,
        pass
    def processEnded(self, status_object):
        #print 'processEnded (mplayer =', mplayer, ')'
        #print "Mplayer processEnded, status %d" % status_object.value.exitCode
        if self is mplayer: # the main player automatically goes on
            if not self.paused:
                play(NextSong(f=stdout, userrequest=False))
    def stop(self):
        if self.paused: self.pause()
        self.transport.write('q\n')
    def pause(self):
        self.transport.write('p\n')
        self.paused = not self.paused

class Mplayer_stopped:
    paused = False
    stopped = True
    def stop(self):
        pass
    def pause(self):
        pass
mplayer_stopped = Mplayer_stopped()

def play(song):
    global mplayer
    if song.startswith('-'): return
    mplayer = Mplayer()
    # ?? why does 'wc' work without full path, but not 'mplayer'?
    reactor.spawnProcess(mplayer, mplayer_path, [mplayer_path, "-slave", "-really-quiet", "-ao", "alsa", song], {})

def RandomPoolSong():
    return random.choice(User_pool)

def Main(pool, selectSongFunc = RandomPoolSong):
    """
    Enters into the main play/event loop.
    pool: list of filenames that can be selected using commandline
    selectSongFunc: a function, taking no arguments but returning a
    string (path to the next song to play). If not given, a random
    pool song is choosen instead.
    
    """
    global User_selectSongFunc, User_pool
    User_selectSongFunc = selectSongFunc
    User_pool = pool

    # tcp connections
    factory = protocol.Factory()
    factory.protocol = Prompt
    reactor.listenTCP(28443, factory)

    # commandline connection
    global commandline
    commandline = Prompt()
    stdio.StandardIO(commandline)

    global mplayer
    mplayer = mplayer_stopped
    args = sys.argv[1:]
    if args: Command(' '.join(sys.argv[1:]))

    reactor.run()

    mplayer.stop()

if __name__ == '__main__':
    print 'Do not run directly, try playlist-example.py instead.'

