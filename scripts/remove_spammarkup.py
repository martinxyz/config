# quickly remove spamassassin markup from a whole Maildir/ tree
# (X-Spam-* lines, and following lines starting with a tab)
from os.path import join, exists
from os import rename, unlink, walk

def work(filename):
    if filename.endswith('.markup'): return
    if not exists(filename + '.markup'):
        rename(filename, filename + '.markup')
    f = open(filename, 'w')
    found = False
    out = False
    for line in open(filename + '.markup'):
        if out:
            f.write(line)
            continue
        if found and not line.startswith('\t'): found = False
        if line.startswith('X-Spam-'): found = True
        if line == '\n': out = True
        if not found: f.write(line)
    f.close()
    unlink(filename + '.markup')


for root, dirs, files in walk('Maildir'):
    for name in files:
        print join(root, name)
        work(join(root, name))

#work('ddd')

