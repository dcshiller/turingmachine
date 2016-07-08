require_relative 'window_organization'
require_relative 'menu'
require_relative 'program_editor'

class MainMenu < Menu

  MAIN_MENU_OPTIONS = ["What is a Turing Machine?",
             "Watch Sample",
             "Edit/Write Program",
             "Load Program (t.b.a)",
             "Options (t.b.a)",
             "Exit"]

  MAIN_MENU_EFFECTS = [ nil,
                  Proc.new {ProgramReader.new.run_program},
                  Proc.new {ProgramEditor.new},
                  nil,
                  nil,
                  Proc.new { system("clear") and exit } ]


  def initialize
    super(MAIN_MENU_OPTIONS, MAIN_MENU_EFFECTS, "Turing Machine Simulator")
  end

end
