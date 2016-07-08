require 'io/console'
require 'colorize'
require 'byebug'
require_relative 'lib/program_reader'
require_relative 'lib/menus/main_menu'
require_relative 'lib/menus/splash'
require_relative 'lib/tape'
require_relative 'lib/menus/full_screen_gets'

class TuringSim
  include WinOrg, KeyInput #Splash,

  def initialize
    set_terminal_settings and at_exit { reset_terminal_settings and system("clear") }
    splash
    MainMenu.instance
  end

  private

  def reset_terminal_settings
    system("setterm -cursor on")
    STDIN.echo = true
    STDIN.cooked!
    #system("clear")
  end

  def set_terminal_settings
    system("setterm -cursor off")
    STDIN.echo = false
  end

end

TuringSim.new
