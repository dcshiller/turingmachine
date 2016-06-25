require_relative 'machine_state'
require_relative 'tape'
require_relative 'display'
require 'byebug'


class ProgramReader
	attr_reader :tape

	def initialize
		@pause = false
		@counter = 0
		@tape = Tape.new(:x,:x,:x,:"0",:x,:x)
		@display = Display.new(@tape)
		#first_state = MachineState.halt(0)
		first_state = MachineState.make_adder
		#first_state = MachineState.make_adder
		@program_state = first_state
		@finished = false
		at_exit {system("clear")}
	end

	def counter
		@counter += 1
	end


	def display_thread
		Thread.new do
			loop do
				@display.render(@program_state)
				sleep(0.1)
				Thread.pass
			end
		end
	end

	def program_thread
		Thread.new do
			until @finished
				current_mark = @tape.get_mark_under_reader
				next_action = @program_state.get_behavior(current_mark)
				case next_action
				when :halt
					@finished = true
					break
				when :right
					move_right
					#tape.move_right_one_full
				when :left
					move_left
				when :markx
					write_mark(:x)
				when :mark0
					write_mark(:"0")
				end
				@program_state = @program_state.get_next_state(current_mark)
			end
		end
	end

	def write_mark(mark)
		sleep(0.5)
		tape.write_mark(mark)
		sleep(0.5)
	end

	def run_program
		display = display_thread
		program_thread.join
		display_thread.join
	end

	def move_right
		tape.offset_right
		sleep(0.2)
		Thread.pass
		tape.offset_right
		sleep(0.2)
		Thread.pass
		tape.offset_right
		sleep(0.5)
		Thread.pass
	end

	def move_left
		tape.offset_left
		sleep(0.2)
		Thread.pass
		tape.offset_left
		sleep(0.2)
		Thread.pass
		tape.offset_left
		sleep(0.5)
		Thread.pass
	end

end


if __FILE__ == $PROGRAM_NAME
	p = ProgramReader.new
	p.run_program
end
