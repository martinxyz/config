#!/usr/bin/env python3
"""Backup a directory into timestamped snapshots using rsync and hardlinks.

For installation, write a python script in the same directory like this one:
---
import rsyncbackup as rb
rb.ssh += ' -i /root/.ssh/netbackup'

rb.backup('nordfenster:/', '/backup-nordfenster', ping='nordfenster')
#         src (for rsync)   backupdir (local)
# optionally pings the host before starting to avoid rsync error if down

# local backup to USB stick (no root required)
rb.backup('/home/martin/', '/backupstick/martin')
---

This script is expected to run about hourly via cron. Example:
17 * * * * flock /tmp/backuplock python /home/martin/scripts/backup_martin.py

The first time you will be asked to create an excludes file for
rsync. The script will look at the uptime and start only if the local
system is idle. After some time it will start no matter what.
"""

# basic rsync command and flags
rsync = 'rsync -az --delete-excluded --numeric-ids --exclude-from=excludes '
ssh = 'ssh -o BatchMode=yes '

DAY = 24*60*60.0

# here you describe how many snapshots to keep
# each slot stands for a time period
backuptimes = [
    # a new backup will be made if the first slot is empty
    # and the system is idle, or if both the first and the
    # second slot are empty
    2   * DAY,  # keep one backup between 0 and 2 days old
    4   * DAY,  # keep one backup between 2 and 4 days old
    8   * DAY,  # ...
    16  * DAY,
    32  * DAY,
    64  * DAY,
    128 * DAY,
    ]

#################################
### END OF CONFIGURATION PART ###
#################################

import os, time

excludes_example_content = """
/proc
/mount
/cdrom
"""

now = time.time()

def backup_age(filename):
    if not os.path.isdir(filename):
        return None
    try:
        result = now - time.mktime(time.strptime(filename, '%Y%m%d'))
        return result
    except ValueError:
        return None

def scan_old_backups():
    "returns tuple: (newest backup file, slot id of newest backup, list of directories to remove)"
    slots = len(backuptimes)*[None]
    delete = []
    now = time.time()
    for filename in os.listdir('.'):
        dt = backup_age(filename)
        if dt is None:
            continue
        # print 'Processing:', filename, 'dt =', dt
        i = 0
        while i < len(slots) and dt > backuptimes[i]:
            i += 1
        if i == len(slots):
            # print 'Deleting over-aged backup', filename
            delete.append(filename)
            continue
        if slots[i] is None:
            slots[i] = filename
        else:
            old_dt = backup_age(slots[i])
            # keep only the oldest one in a slot
            # print 'slot conflict:', (slots[i], old_dt), 'vs', (filename, dt)
            if old_dt > dt:
                delete.append(filename)
            else:
                delete.append(slots[i])
                slots[i] = filename
    i = 0
    # print slots
    while i < len(slots) and slots[i] is None:
        i += 1
    if i == len(slots):
        return (None, i, delete)
    else:
        return (slots[i], i, delete)

def backup(src, backupdir, ping=None, force=False):
    assert os.path.exists(backupdir), 'Please the create "%s" yourself and set proper permissions' % backupdir
    old_cwd = os.getcwd()
    os.chdir(backupdir)
    try:
        assert os.path.exists('excludes'), 'Please create an "excludes" file in the backup directory. Suggested content:' + excludes_example_content
        (lastbackup, needed, delete) = scan_old_backups()
        if force:
            print('Forced')
            needed = 2
        if needed == 0:
            # print 'Not needed.'
            return True
        if needed == 1:
            # load average last 5 minutes
            load = float(os.popen('uptime').read().split()[-2][:-1])
            # print 'Load', load,
            if (load > 0.0):
                # print '--> later.'
                return True
            # print '--> starting.'
        if needed > 1:
            pass  # print 'Too many emtpy slots, starting without checking load.'
        if needed > 2:
            print(src)
            print('WARNING: no recent backups found, maybe something is wrong!')
            print('         (Three or more empty slots. Retrying...)')

        if ping and os.system('ping -q -c 1 ' + ping + ' >/dev/null') != 0:
            # print ping, 'does not respond to ping, skipping'
            return

        if not os.path.exists('next'):
            os.system('mkdir next')
        else:
            print('Continuing with existing next/ directory from interrupted or erroneous rsync.')
        timestamp = time.strftime('%Y%m%d')

        assert not '"' in ssh
        command = rsync + '-e "'+ssh+'" ' + src + ' ./next/'
        if lastbackup:
            command += ' --link-dest=' + os.path.join(backupdir, lastbackup)
        result = os.system(command)
        if result != 0:
            print(src)
            print('WARNING: rsync returned exit code', + os.WEXITSTATUS(result))
            print('         the next/ directory might hold partial results')
            return
        # os.system('touch next') # rsync resets mtime (or ctime?... only one of them)
        os.rename('next', timestamp)

        for filename in delete:
            # print 'Deleting old backup', filename
            assert os.system('rm -rf ' + filename) == 0

    finally:
        os.chdir(old_cwd)
