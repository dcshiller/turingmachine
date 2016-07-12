require_relative 'window_organization'
require_relative 'menu'
require_relative 'program_editor'

class MainMenu < Menu
  include WinOrg

  MAIN_MENU_OPTIONS = ["What is a Turing Machine?",
    "Watch Sample",
    "Edit/Write Program",
    "Load Program",
    "Options (t.b.a)",
    "Exit"
  ]

  MAIN_MENU_EFFECTS = [ nil,
    " ProgramReader.new.run_program",
    " ProgramEditor.new",
    "
      begin
        file_name = './programs/' + send(:full_screen_gets, 'File name:').chomp + '.tm'
        yaml_program_states = File.read(file_name)
        @program_states = YAML.load(yaml_program_states)
      rescue
        flash('file not found')
        retry
      end
    ",
    " nil",
    " system('\printf \ec') and break"
  ]

  def initialize
    super(MAIN_MENU_OPTIONS, MAIN_MENU_EFFECTS, "Turing Machine Simulator")
  end

end
