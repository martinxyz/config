# cronjob script to backup to USB sticks (need to be user-mountable)

from os import system, path
import rsyncbackup as rb
targets = [
  '/backupstick',
  '/backupstick_sony',
  '/backupstick_sandisk',
  '/backupstick_usbplatte',
]
success = 0
for target in targets:
  system('mount ' + target + ' 2>/dev/null')
  if not path.isdir(target + '/lost+found'):
    continue
  try:
    rb.backup('/home/martin/', target + '/martin')
  finally:
    system('sync')
  success += 1

assert success > 0, 'No USB sticks plugged in for backup!'

