require_relative '../machinelogic/machine_state'
require_relative 'tape'
require_relative 'display'
require 'byebug'

class ProgramReader
	attr_reader :tape

	def initialize
		@pause = false
		@tape = Tape.new(:x,:x,:x,:"0",:x,:x)
		@display = Display.new(@tape)
		@program_state = $program
		@finished = false
		at_exit {full_clear}
	end

	def display_thread
		Thread.new do
			until @finished
				@display.refresh_program_state(@program_state)
				@display.render_panels
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