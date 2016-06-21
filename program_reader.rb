require_relative 'machine_state'
require_relative 'tape'

class ProgramReader

	def initialize
		@counter = 0
		@tape = Tape.new
		null_state = MachineState.halt(0)
		@program_start = null_state
		@finished = false
	end

	def counter
		@counter += 1
	end

	def run_program
		until @finished
			@tape.render
			current_symbol = @tape.get_symbol_under_reader
			next_action = @program_state.get_behavior(current_symbol)
			case next_action
			when :halt
				@finished = true
				break
			when :right
			when :left
			when :markx
			when :mark0
			end
			@program_state = @program_state.get_next_state
		end
	end

end
