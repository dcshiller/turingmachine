require_relative 'machine_state'
require_relative 'tape'
require 'byebug'


class ProgramReader
	attr_reader :tape

	def initialize
		@counter = 0
		@tape = Tape.new([:x,:x,:x,:"0",:x,:x])
		#first_state = MachineState.halt(0)
		#first_state = MachineState.make_simple_program
		first_state = MachineState.make_adder
		@program_state = first_state
		@finished = false
	end

	def counter
		@counter += 1
	end

	def run_program
		t1 = Thread.new do
			until @finished
				@tape.render
				current_symbol = @tape.get_symbol_under_reader
				next_action = @program_state.get_behavior(current_symbol)
				case next_action
				when :halt
					@finished = true
					break
				when :right
					tape.move_right_one_full
				when :left
					tape.move_left_one_full
				when :markx
					tape.change_mark(:x)
				when :mark0
					tape.change_mark(:"0")
				end
				@program_state = @program_state.get_next_state(current_symbol)
			end
		end
		t1.join
	end

end


if __FILE__ == $PROGRAM_NAME
	p = ProgramReader.new
	p.run_program
end
