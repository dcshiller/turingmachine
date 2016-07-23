require_relative '../machinelogic/machine_state'
require_relative 'tape'
require_relative 'display'
require 'byebug'

class ProgramReader
	attr_reader :tape

	def initialize
		@pause = false
		@tape = Tape.new(:x,:x,:x,:"0",:x,:x)
    @log = []
		@display = Display.new(@tape, @log)
		@program_state = $program
		@finished = false
		#at_exit {full_clear}
	end

	def display_thread
		Thread.new do
			until @finished
				@display.refresh_program_state(@program_state)
				@display.render_panels
				# sleep(0.1)
				Thread.pass
			end
		end
	end

  def log_write(string)
    @log << "#{@program_state.number_tag}: #{string}" +
            " and go to" +
            " #{@program_state.get_next_state(@tape.get_mark_under_reader).number_tag}"
  end

	def move(direction)
    log_write("Move #{direction}")
    3.times do |idx|
      tape.offset_to(direction)
  		sleep(0.2)
      sleep(0.3) if idx == 2
  		Thread.pass
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
					# break
				when :right, :left
					move(next_action)
				when :markx, :mark0
					write_mark(next_action.to_s[-1].to_sym)
				end
				@program_state = @program_state.get_next_state(current_mark)
			end
		end
	end

  def run_program
    display = display_thread
    program_thread.join
    display_thread.join
  end

	def write_mark(mark)
    log_write("Write #{mark}")
		sleep(0.5)
		tape.write_mark(mark)
		sleep(0.5)
	end
end


if __FILE__ == $PROGRAM_NAME
	p = ProgramReader.new
	p.run_program
end
