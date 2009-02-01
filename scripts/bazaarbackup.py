#!/usr/bin/env python
import rsyncbackup

# basic rsync command and flags
rsync  = 'rsync -az --delete-excluded --exclude-from=excludes'
rsync += ' -e "ssh -i /home/martin/.ssh/id_dsa_netbackup"'

rsyncbackup.rsync = rsync

# backup(src='rsync path', dst='local directory')
# ping before starting avoids rsync error if host is down
rsyncbackup.backup('bazaar:/home/martin/', '/home/martin/backup-bazaar')

