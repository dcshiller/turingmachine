
module KeyInput

def get_keystroke
  STDIN.raw!
  key = STDIN.getc.chr
  if key == "\e" then key << STDIN.read_nonblock(3) rescue nil end
  if key == "\e" then key << STDIN.read_nonblock(2) rescue nil end
  STDIN.cooked!
  key
end

end
