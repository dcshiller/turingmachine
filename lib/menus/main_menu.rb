require_relative '../fundamentals/window_organization'
require_relative 'menu'
require_relative 'program_editor'

class MainMenu < Menu
  include WinOrg

  MAIN_MENU_OPTIONS = [
    "What is a Turing Machine?",
    "Watch Sample",
    "Edit/Write Program",
    "Load Program",
    "Options (t.b.a)",
    "Exit"
  ]

  MAIN_MENU_EFFECTS = [
    Proc.new { },
    Proc.new { ProgramReader.new.run_program },
    Proc.new { ProgramEditor.new },
    Proc.new { load_program },
    Proc.new { },
    Proc.new { full_clear; exit}
  ]

  def load_program
    begin
      response = full_screen_gets('File name:' ).chomp
      unless response == 'back'
        file_name = './programs/' + response + '.tm'
        yaml_program_states = File.read(file_name)
        @program_states = YAML.load(yaml_program_states)
      end
    rescue
      flash("file not found \n" + center("('back'returns to menu)"))
      retry
    end
  end

  def initialize
    super(MAIN_MENU_OPTIONS, MAIN_MENU_EFFECTS, "Turing Machine Simulator")
  end

end
