require 'io/console'
require 'colorize'
require 'byebug'
require_relative 'program_reader'
require_relative 'menu'
require_relative 'splash'
require_relative 'tape'

class TuringSim

  include Menu, Splash

  def initialize
    set_terminal_settings and at_exit { reset_terminal_settings and system("clear") }
    splash
    menu
  end

  private

  def center(string)
    length = string.uncolorize.length
    puts " " * ((@cols - length) /2) + string + " " * ((@cols - length) /2)
  end

  def get_keystroke
    STDIN.raw!
    key = STDIN.getc.chr
    STDIN.cooked!
    key
  end

  def justify(string)
    length = string.uncolorize.length
    puts (" " * (@cols/3)) + string + (" " * (2*(@cols)/3-length + (1)))
  end

  def refresh_window_information
    @cols, @rows = `tput cols`.to_i, `tput lines`.to_i
  end

  def reset_terminal_settings
    system("setterm -cursor on")
    STDIN.echo = true
    STDIN.cooked!
    #system("clear")
  end

  def selected(string)
    string.red
  end

  def set_terminal_settings
    system("setterm -cursor off")
    STDIN.echo = false
  end

end


TuringSim.new
