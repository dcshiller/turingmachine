
module KeyInput

def get_keystroke
  STDIN.raw!
  key = STDIN.getc.chr
  STDIN.cooked!
  key
end

end
