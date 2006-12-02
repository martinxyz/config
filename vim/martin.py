'''
Testground.
'''
import vim

lastcursor = None

def mycomplete():
  global lastcursor, rejectlist, original

  win = vim.current.window
  buf = vim.current.buffer
  (row, col) = win.cursor
  line = buf[row-1]

  if lastcursor != win.cursor:
      rejectlist = []
      original = ((row, col), line)
  else:
      ((row, col), line) = original

  before, after = line[:col+1], line[col+1:]
  partial = before.split()[-1]
  if not partial: return
  before = before[:-len(partial)]

  def search(s, reverse=False):
      l = s.split()
      if reverse: l.reverse()
      for word in l:
          if word.startswith(partial):
              if len(word) >= len(partial)+3:
                  if word not in rejectlist:
                      return word

  start = row-1
  stop = row-1
  result = search(before, reverse=True) or search(after, reverse=False)
  while True:
      if result: break
      moved = False
      start -= 1
      if start >= 0:
          result = search(buf[start], reverse=True)
          moved = True
      if result: break
      stop += 1
      if stop < len(buf):
          result = search(buf[stop], reverse=False)
          moved = True
      if not moved:
          break

  if not result:
      rejectlist = []  # cycle
      result = partial # tell that we're cycling
  else:
      rejectlist.append(result)

  buf[row-1] = before + result + after
  col += len(result)-len(partial)
  win.cursor = (row, col)

  lastcursor = win.cursor
