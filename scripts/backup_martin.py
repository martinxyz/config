# cronjob script to backup to USB sticks (need to be user-mountable)

from os import system, path
import rsyncbackup as rb
targets = [
  # '/backupstick_100a',
  '/backupstick_100b',
  '/backupstick_100c',
  '/teraplatte',
  #'/backupstick',
  #'/backupstick_sony',
  #'/backupstick_sandisk',
  #'/backupstick_usbplatte',
  #'/backupstick_sony2',
]
success = 0
for target in targets:
  mounted = path.isdir(target + '/lost+found')
  if not mounted:
      system('mount ' + target + ' 2>/dev/null')
  if path.isdir(target + '/lost+found'):
    try:
      rb.backup('/home/martin/', target + '/martin')
      system('sync -f ' + target + '/martin')
    finally:
      if not mounted:
        system('umount ' + target)
    success += 1

assert success > 0, 'No USB sticks plugged in for backup!'

