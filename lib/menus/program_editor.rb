
require_relative 'window_organization'
require_relative '../machine_state'
require_relative 'panels'

class ProgramEditor
    include WinOrg

  def initialize(program = MachineState.make_simple_program)
    refresh_window_information
    @program = program
    window = make_and_combine_panels
    window.draw_content
  end

  def make_and_combine_panels
    states =  get_states
    top_panel = Panel.new(1, 0.1,[[],[center("Program Editing Menu")]], :light_black)
    @state_list_panel = Panel.new(0.7, 0.8, states, :white)
    @state_innards_panel = Panel.new(0.3, 0.8, [["right panel"]], :light_white)
    middle_panels = @state_list_panel.place_side_by_side(@state_innards_panel)
    top_and_middle_panels = top_panel.place_on_top_of(middle_panels)
    bottom_panel = Panel.new(1, 0.1,[[""]], :light_black)
    all_panels = top_and_middle_panels.place_on_top_of(bottom_panel)
  end

  def get_states
    @program.state_array.collect {|program_state| program_state.number.to_s}
  end

  #
  # def edit_panel
  #   @program.each {|state| print_state(state)}
  # end
  #
  # def print_state(state)
  #   puts state
  # end

end

ProgramEditor.new
