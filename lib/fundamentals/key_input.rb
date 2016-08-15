
module KeyInput

def get_keystroke
  STDIN.raw!
  STDIN.echo = false
  # STDOUT.sync = false
  key = STDIN.getch#.chr
  if key == "\e" then key << STDIN.read_nonblock(3) rescue nil end
  if key == "\e" then key << STDIN.read_nonblock(2) rescue nil end
  STDIN.cooked!
  # STDIN.echo = true
  # STDOUT.sync = true
  key
end

end
