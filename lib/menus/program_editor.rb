
require_relative 'window_organization'
require_relative '../machine_state'
require_relative '../key_input'
require 'colorize'
require 'io/console'
require_relative 'panels'

class ProgramEditor
    include WinOrg, KeyInput

  def initialize(program = MachineState.make_adder)
    refresh_window_information
    @selection = -1
    @program = program
    @program_state_names = get_program_state_names(@program)
    selection_loop
  end

  def make_and_combine_panels
    top_panel = Panel.new(1, 0.1,[[],[center("Program Editing Menu")]], :light_black)

    state_list_panel = Panel.new(0.7, 0.8, @program_state_names, :white)
    state_innards_panel = Panel.new(0.3, 0.8, [["Right panel"]], :light_white)

    bottom_panel = Panel.new(1, 0.1, [[""]], :light_black)

    middle_panels = state_list_panel.place_side_by_side(state_innards_panel)
    top_and_middle_panels = top_panel.place_on_top_of(middle_panels)

    top_and_middle_panels.place_on_top_of(bottom_panel)
  end

  def color_selection
    @program_state_names[@selection-1][0] = @program_state_names[@selection-1][0].black if @program_state_names[@selection-1]
    @program_state_names[@selection+1][0] = @program_state_names[@selection+1][0].black if @program_state_names[@selection+1]
    @program_state_names[@selection][0] = @program_state_names[@selection][0].red if @selection >= 0
  end

  def get_program_state_names(program)
    MachineState.get_downstream_states(program).collect {|program_state| [program_state.number_tag.black]}
  end

  def selection_loop
    loop do
       color_selection
       window = make_and_combine_panels
       system("clear")
       window.draw_content
      case get_keystroke
      when  "\e[A"
        @selection -= 1 unless @selection < 1
      when "\e[B"
        @selection += 1 unless @selection >= @program_state_names.length - 1
      when "\r", "\n"
        effects[selection].call
      when "b"
        break
      else
      end
    end
  end

end

ProgramEditor.new
