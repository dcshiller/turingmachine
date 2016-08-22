require_relative '../fundamentals/window_organization'
require_relative '../fundamentals/machine_writer'
require_relative 'menu'
require_relative 'program_editor'
require_relative 'introduction_info'

class MainMenu < Menu
  include WinOrg, MachineWriter

  MAIN_MENU_OPTIONS = [
    "What is a Turing Machine?",
    "Run Program",
    "Edit/Write Program",
    "Load Program",
    "Exit"
  ]

  MAIN_MENU_EFFECTS = [
    Proc.new { introduction_info },
    Proc.new { ProgramReader.new.run_program },
    Proc.new { ProgramEditor.new },
    Proc.new { load_program },
    Proc.new do
      full_clear;
      system("setterm -cursor on") #done at exit, but to double-check!
      STDIN.echo = true
      exit
    end
  ]

  def initialize
    super(MAIN_MENU_OPTIONS, MAIN_MENU_EFFECTS, "Turing Machine Simulator")
  end

end
