require 'io/console'
require 'colorize'
require 'byebug'
require_relative 'lib/display/program_reader'
require_relative 'lib/menus/main_menu'
require_relative 'lib/menus/splash'

class TuringSim
  include WinOrg, KeyInput

  def initialize
    $program = MachineState.make_adder
    set_terminal_settings and at_exit { system("clear"); reset_terminal_settings }
    system("printf '\e[8;40;120t'")
    splash
    MainMenu.instance
    system("setterm -cursor on")
    STDIN.echo = false
  end

  private

  def reset_terminal_settings
    system("setterm -cursor on")
    STDIN.echo = true
    STDIN.cooked!
  end

  def set_terminal_settings
    system("setterm -cursor off")
    STDIN.echo = false
  end

end

TuringSim.new
