require_relative '../machinelogic/machine_state'
require_relative '../fundamentals/machine_writer'
require_relative 'tape'
require_relative 'display'
require_relative '../fundamentals/key_input'
require 'io/wait'

class ProgramReader
	include KeyInput, WinOrg, MachineWriter
	attr_reader :tape

	MENU_EFFECTS = [
			Proc.new { set_arguments },
			Proc.new { "break" },
			Proc.new { reset },
			Proc.new { run_program_to_end },
			Proc.new { load_program },
			Proc.new { @done = true; "break" }
	]

	def initialize
		@arguments = [1,1]
		@update = {tape: true, menu: true}
		@display = Display.new(@tape, @log, @update)
		reset
		@first_time = true
	end

	def run_program
		loop do
			@display.refresh_program_state(@program_state)
			step_program
			handle_input if STDIN.ready?
			break if @done
		end
	end

	private

	def handle_input
		@update[:menu] = true
		@display.render_panels
		loop do
			case get_keystroke
			when "\e[A"
				@display.selection -= 1 unless @display.selection <= 0
			when "\e[B"
				@display.selection += 1 unless @display.selection >= 5
			when "\n", "\r"
				should_break = self.instance_eval &MENU_EFFECTS[@display.selection]
				break if should_break == "break"
			end
			@update[:menu] = true
			@display.render_panels
		end
		@update[:menu] = true
	end

	def log_write(string)
		@update[:tape] = true
		@log << "#{@program_state.number_tag}: #{string}" +
		" and go to" +
		" #{@program_state.get_next_state(@tape.get_mark_under_reader).number_tag}"
	end

	def move(direction, quickly)
    log_write("Move #{direction}")
    3.times do |idx|
      tape.offset_to(direction)
			@update[:tape] = true
			unless quickly || STDIN.ready?
				@display.render_panels
				idx == 2 ? sleep(0.5) : sleep(0.2)
			end
    end
	end

	def reset
		@finished = false
		set_initial_tape_state
		@log = []
		@display.reset(@tape,@log) if @display
		@update[:tape] = true if @update
		@program_state = $program
	end

	def run_program_to_end
		current_mark = @tape.get_mark_under_reader
		until @program_state.get_behavior(current_mark) == :halt
			step_program(true)
		end
			@update[:tape] = true
			@display.render_panels
	end

	def set_arguments
		argument_strings = full_screen_gets("Arguments: ", ["Arguments must be in x,y,z format.", ""]).split(",")
		@arguments = argument_strings.map {|arg_string| arg_string.to_i}
		reset
	end

	def set_initial_tape_state
		initial_symbols = []
		@arguments.each do |argument|
			argument.times {initial_symbols << :x}
			initial_symbols << :"0"
		end
		@tape = Tape.new(*initial_symbols)
	end

	def step_program(quickly = false)
		current_mark = @tape.get_mark_under_reader
		next_action = @program_state.get_behavior(current_mark)
		return if @finished
		case next_action
		when :halt
			log_write("Halted")
			@finished = true
		when :right, :left
			move(next_action, quickly)
		when :markx, :mark0
			write_mark(next_action.to_s[-1].to_sym, quickly)
		end
		unless quickly || @finished || STDIN.ready?
			@display.render_panels
		end
		@program_state = @program_state.get_next_state(current_mark)
	end

	def write_mark(mark, quickly)
    log_write("Write #{mark}")
		sleep(0.5) unless quickly || STDIN.ready?
		tape.write_mark(mark)
		sleep(0.5) unless quickly || STDIN.ready?
	end
end
