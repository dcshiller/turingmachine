
require_relative 'window_organization'
require_relative '../machine_state'
require_relative 'panels'

class ProgramEditor

  def initialize(program = MachineState.make_simple_program)
    @program = program
    states = [["state 1"], ["state 2"], ["state 3"]]
    @state_list_panel = Panel.new(0.7, 0.7, states, :black)
    @state_innards_panel = Panel.new(0.3, 0.7, [["aaaaa"]], :red)
    @state_list_panel.place_side_by_side(@state_innards_panel).draw_content
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
