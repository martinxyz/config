#!/usr/bin/env python3
"""
Music playlist server controlling mplayer as backend.
See playlist-example.py to find out how to use it.
"""
mpv_path = '/usr/bin/mpv'
# echo '{ "command": ["get_property", "playback-time"] }' | socat - ~/.cache/mplaylists-mpvsocket

# playlog = None
playlog_path = '/home/martin/sich/playlog'
playlog = open(playlog_path, 'ab')

import os, sys, random, re, time, socket, tempfile, uuid
stdout = sys.stdout

### globals

User_selectSongFunc = None
mplayer = None
User_pool = None
tempdir = None
commandline = None

### Helper functions, they all return a list of filenames

def ReadDirectory(dir):
    "returns a list of filenames in the directory, with dir prefix"
    dir = dir.encode('utf8')
    result = []
    for filename in os.listdir(dir):
        result.append(os.path.join(dir, filename))
    result.sort()
    return result
def ReadPlaylist(filename):
    "returns a list of filenames (maybe you'll need to make them absolute paths)"
    result = []
    for line in open(filename, 'rb').readlines():
        line = line.split(b'#')[0].strip()
        if line: result.append(line)
    return result
    
def CopySongs(playlist, regexp = None, remove=False):
    "returns a list of the strings matching regexp, without removing them from playlist"
    if not regexp and not remove: return playlist[:]
    try:
        regexp = regexp.decode('utf8', errors='ignore')
    except:
        pass
    result = []
    regexp = regexp.replace(' ', '.*') # "easy" regexps
    regexp = re.compile(regexp, re.IGNORECASE)
    for filename in playlist[:]:
        # allow to search latin1 and unicode filenames by unicode query
        try:
            fn = filename.decode('utf8')
        except UnicodeDecodeError:
            try:
                fn = filename.decode('latin1')
            except UnicodeDecodeError:
                fn = filename.decode('utf8', errors='ignore')
        if regexp.search(fn):
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
    for line in open(playlog_path, 'rb'):
        name = line.split(b' ', 1)[1][:-1]
        if name not in count: continue
        count[name] += 1

    l = [(count, name) for (name, count) in list(count.items())]
    l.sort()
    i = len(l) * percent // 100
    return [name for count, name in l[:i]]


### Fuzzy string matching

def filename_words(filename):
    s = filename.split(b'/')[-1]
    words = re.findall(rb'[a-zA-Z]+', s)
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
        write2any(self.output, s + '\n')

    def select(self):
        raise NotImplemented('abstract method')

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
        except ValueError as IndexError:
            next = self.random(playlist)

        if next in self.history:
            next = self.random(playlist)

        next_score = filename_similarity(prev, next)
        print('next', next, 'score', next_score)
        better = []

        sample_size = len(playlist)//10
        if sample_size < 100:
            sample_size = len(playlist)

        for candidate in random.sample(playlist, sample_size):
            if candidate in self.history:
                continue
            score = filename_similarity(prev, candidate)
            if score > next_score:
                better.append(candidate)
    
        print('better:', len(better))
        print('\n'.join([fn.decode('utf8', errors='replace') for fn in better]))
        if better:
            if random.randrange(5) == 0:
                print('Choosing random anyway.')
                next = self.random(playlist)
            else:
                print('Chossing a better one.')
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
        write2any(f, 'From the stack: (%d items left now)\n' % (len(future)))
    else:
        filename = User_selectSongFunc(history, userrequest, f)
        assert filename
    if playlog and history:
        t = time.time()
        dt = t - last_button_t
        if userrequest:
            playlog.write(b'AFTER %.3f SKIP ' % dt + history[-1] + b'\n')
        else:
            playlog.write(b'AFTER %.3f DONE ' % dt + history[-1] + b'\n')
        #playlog.flush()
        last_button_t = t
    write2any(f, os.path.basename(filename).replace(b'_', b' ').decode('utf8', errors='replace') + '\n')
    history.append(filename)
    return filename.split(b' # ')[0] # remove "comment" keywords

def PrevSong(f = stdout):
    global future, history
    if len(history) < 2:
        return b''
    # the current one is already in the history
    filename = history.pop()
    future.insert(0, filename)
    # the previous one

    filename = history[-1]
    write2any(f, os.path.basename(filename).replace(b'_', b' ').decode('utf8', errors='replace') + '\n')
    return filename

def Command(command, f = stdout):
    global future, history
    # interpret as song selection string
    info = None
    if not command:
        future = []
        write2any(f, 'Stack cleaned.\n')
    else:
        arg = command[1:].strip()
        arg_regexp = arg.replace(b' ', b'.*') # "easy" regexps
        command = command[0:1]
        if command == b'-':
            taken = TakeSongs(future, arg_regexp)
            info = 'Removed %d songs from the stack.' % (len(taken))
        if command == b'm' and future:
            future = []
            mplayer.stop()
        if (command == b'm' and arg) or command == b'+':
            added = CopySongs(User_pool, arg_regexp)
            info = 'Added %d songs to the stack.' % (len(added))
            future += added
            if added: 
                if command == b'm': mplayer.stop()
                random.shuffle(future)
        if command == b'=':
            added = CopySongs(User_pool, arg_regexp)
            added.sort()
            info = 'Appended %d songs to the stack.' % (len(added))
            future = future + added
        if command == b'>':
            added = CopySongs(User_pool, arg_regexp)
            random.shuffle(added)
            info = 'Inserted %d songs to the stack.' % (len(added))
            future = added + future

    if future:
        write2any(f, '--- Stack ---\n')
        if len(future) > 100:
            write2any(f, '[not listing %d files]\n' % len(future))
        else:
            write2any(f, '\n'.join([fn.decode('utf8', errors='replace') for fn in future]) + '\n')
        write2any(f, '--- End of Stack ---\n')
    else:
        write2any(f, 'Stack is empty.\n')
    if info: write2any(f, info + '\n')

### Unicode hack

def write2any(output, s):
    # write a unicode string to stdout (utf8) or to tcp socket (bytes)
    if hasattr(output, 'encoding') and output.encoding == 'utf-8':
        output.write(s)
    else:
        output.write(s.encode('utf-8'))

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
    delimiter = b'\n'
    def connectionMade(self):
        self.sendLine(b'(enter h for help)')
    def lineReceived(self, line):
        global mplayer

        # wireless numpad hacks
        line = line.replace(b'\x1b[2~', b'0')
        line = line.replace(b'\x1b[8~', b'1')
        line = line.replace(b'\x1b[B', b'2')
        line = line.replace(b'\x1b[6~', b'3')
        line = line.strip()

        if line == b'0': line = b's'
        if line == b'1': line = b''
        if line == b'2': line = b'p'
        if line == b'3': line = b'n'
        if line == b'*': line = b'm http'

        if not line or line == b'n':
            if mplayer.paused:
                mplayer.pause()  # continue
                self.sendLine(b'[continued]')
            else:
                mplayer.stop()
                play(NextSong(f=self.transport, userrequest=True))
        elif line == b'h' or line == b'?':
            self.sendLine(help.encode('utf8'))
        elif line == b'P':
            # for "play_pause" media key (on headphones)
            if mplayer.paused:
                mplayer.pause()  # continue
            elif mplayer.stopped:
                play(NextSong(f=self.transport, userrequest=True))
            else:
                mplayer.pause()
        elif line == b's':
            if mplayer.paused:
                mplayer.stop()
                mplayer = mplayer_stopped
                PrevSong()
                self.sendLine(b'[stopped]')
            elif mplayer.stopped:
                self.sendLine(b'Already stopped!')
            else:
                mplayer.pause()
                self.sendLine(b'[paused]')
        elif line == b'i':
            if not history:
                print("Nothing, waiting for your first command")
            else:
                self.sendLine(history[-1])
        elif line == 'rm':
            if not history:
                print("Nothing to remove.")
            else:
                try:
                    os.remove(history[-1])
                    #del history[-1]
                except OSError:
                    self.sendLine(b'cannot remove ' + history[-1])
                else:
                    self.sendLine(b'removed ' + history[-1])
            self.lineReceived(b'n')
        elif line == b'p':
            mplayer.stop()
            play(PrevSong(self.transport))
        elif line == b'q' or line == b'k':
            if self is commandline or line == b'k':
                mplayer.stop()
                mplayer = mplayer_stopped
                reactor.stop()
            else:
                self.transport.loseConnection()
        else:
            Command(line.strip(), f=self.transport)

class Mplayer(protocol.ProcessProtocol):
    stopped = False
    def __init__(self, song):
        self.paused = False
        self.uuid = str(uuid.uuid4())
        self.mpv_socket = os.path.join(tempdir, self.uuid)
        print(self.uuid, 'spawning')
        reactor.spawnProcess(self, mpv_path, [mpv_path, "--really-quiet", "--input-ipc-server=" + self.mpv_socket, "--vo=null", song], env=os.environ)
    def __del__(self):
        print(self.uuid, 'destructor')
        try:
            os.remove(self.mpv_socket)
        except FileNotFoundError:
            pass
    def connectionMade(self):
        print(self.uuid, 'Mplayer process started.')
        pass
    def outReceived(self, data):
        print(self.uuid, 'outReceived: %r' % data)
        pass
    def errReceived(self, data):
        print(self.uuid, 'errReceived! %r' % data)
        pass
    def processEnded(self, status_object):
        print(self.uuid, 'processEnded (mplayer =', mplayer, ')')
        print('Mplayer processEnded, status %r' % status_object.value.exitCode)
        if self is mplayer: # the main player automatically goes on
            if not self.paused:
                if status_object.value.exitCode != 0:
                    print(self.uuid, 'non-zero exit code; trying next song')
                    time.sleep(1)
                play(NextSong(f=stdout, userrequest=False))
    def stop(self):
        print(self.uuid, 'stop()')
        if self.paused: self.pause()
        try:  # XXX what if mpv didn't get around to create the pipe yet?
            ds = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            ds.connect(self.mpv_socket)
            ds.send(b'{ "command": ["quit"] }\n')
        except socket.error:
            print(self.uuid, 'sending TERM')
            self.transport.signalProcess('TERM')
        except Exception as e:
            print(self.uuid, 'Exc %r' % e)
    def pause(self):
        print(self.uuid, 'pause()')
        try:
            ds = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            ds.connect(self.mpv_socket)
            ds.send(b'{ "command": ["keypress", "p"] }\n')
            self.paused = not self.paused
        except socket.error:
            print(self.uuid, 'sending TERM')
            self.transport.signalProcess('TERM')
        except Exception as e:
            print(self.uuid, 'Exc %r' % e)

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
    if song.startswith(b'-'): return
    mplayer = Mplayer(song)

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
    global User_selectSongFunc, User_pool, tempdir
    User_selectSongFunc = selectSongFunc
    User_pool = pool

    # tcp connections
    factory = protocol.Factory()
    factory.protocol = Prompt
    reactor.listenTCP(28443, factory, interface="127.0.0.1")

    # commandline connection
    global commandline
    commandline = Prompt()
    stdio.StandardIO(commandline)

    global mplayer
    mplayer = mplayer_stopped
    args = sys.argv[1:]


    with tempfile.TemporaryDirectory(prefix='mplaylists-') as tempdir:

        if args: Command(' '.join(sys.argv[1:]))

        reactor.run()

        mplayer.stop()

if __name__ == '__main__':
    print('Do not run directly, try playlist-example.py instead.')

