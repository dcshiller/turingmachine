require 'io/console'
require 'colorize'
require 'byebug'
require_relative 'lib/display/program_reader'
require_relative 'lib/menus/main_menu'
require_relative 'lib/menus/splash'
# require_relative 'lib/display/tape'

class TuringSim
  include WinOrg, KeyInput #Splash,

  def initialize
    $program = MachineState.make_adder
    set_terminal_settings and at_exit { system("clear"); reset_terminal_settings }
    splash
    MainMenu.instance
    system("setterm -cursor on")
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
