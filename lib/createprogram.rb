
require_relative 'window_organization'
require_relative 'machine_state'


class ProgramCreator

  def initialize(program = nil)
    @program = program
  end

  def edit_panel
    @program.each {|state| print_state(state)}
  end

  def print_state(state)
    puts state
  end

end
