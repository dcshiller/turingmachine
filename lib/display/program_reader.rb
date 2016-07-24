require_relative '../machinelogic/machine_state'
require_relative 'tape'
require_relative 'display'
require_relative '../fundamentals/key_input'
require 'io/wait'
require 'byebug'

class ProgramReader
	include KeyInput, WinOrg
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
				if STDIN.ready?
					i = 0
					until i > 5
						@pause =  true
						# @program_thread.kill
						case get_keystroke
						when "\e[A"
							@display.selection -= 1 unless @display.selection <= 0
						when "\e[B"
							@display.selection += 1 unless @display.selection >= 5
						end
						@display.render_panels
						i +=1
						# @display.selection = @display.selection + 1 if key.chomp == "a"
					end
					@pause = false
						# @program_thread.join
			   end
				@display.refresh_program_state(@program_state)
				@display.render_panels
				# @key = key_thread
				# sleep(0.2)
				# sleep(0.1)
				Thread.pass
			end
		end
	end
	#
	#
	# def key_thread
	# 	Thread.new do
	# 		until @finished
	# 			# sleep(2)
	# 			# `tput sc`
	# 			# full_clear
	# 			# system("stty raw -noecho")
	# 			# STDIN.sync = true
	# 			# debugger
	# 			`tput cup 0 0`
	# 			key = STDIN.getch
	# 			debugger
	# 			@display.selection = @display.selection + 1 if key.chomp == "a"
	# 			Thread.pass
	# 		end
	# 	end
	# end

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
				if @pause then sleep(1) else
					current_mark = @tape.get_mark_under_reader
					next_action = @program_state.get_behavior(current_mark)
					case next_action
					when :halt
						@finished = true
					when :right, :left
						move(next_action)
					when :markx, :mark0
						write_mark(next_action.to_s[-1].to_sym)
					end
					@program_state = @program_state.get_next_state(current_mark)
				end
			end
		end
	end

  def run_program
		@displayThread = display_thread
		@displayThread.abort_on_exception
		# @key = key_thread
    @program_thread = program_thread.join
		@program_thread.abort_on_exception
		@displayThread.join
		# @key.join
		# @key.join
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
