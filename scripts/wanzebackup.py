#!/usr/bin/env python
import rsyncbackup

# backup(src='rsync path', dst='local directory')
# ping before starting avoids rsync error if host is down
rsyncbackup.backup('wanze:/', '/backup-wanze')
rsyncbackup.backup('nordfenster:/', '/backup-nordfenster', ping='nordfenster')

