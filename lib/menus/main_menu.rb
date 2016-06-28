require_relative 'window_organization'
require_relative 'menu'


class MainMenu < Menu

  MAIN_MENU_OPTIONS = ["What is a Turing Machine?",
             "Watch Sample",
             "Edit/Write Program (t.b.added)",
             "Load Program (t.b.a)",
             "Options (t.b.a)",
             "Exit"]

  MAIN_MENU_EFFECTS = [ nil,
                  Proc.new {ProgramReader.new.run_program},
                  nil,
                  nil,
                  nil,
                  Proc.new { system("clear") and exit } ]


  def initialize
    super(MAIN_MENU_OPTIONS, MAIN_MENU_EFFECTS)
  end

end
