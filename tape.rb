require 'colorize'

class Tape
	attr_reader :left, :right, :current_square, :offset

	def change_mark(new_mark)
		sleep(1)
		@current_square = new_mark
		render
		sleep(1)
	end

	def initialize(arguments = Array.new {:"0"})
		@left = Array.new(15, :"0")
		@current_square = arguments.first || :"x"
		@right = arguments + Array.new(15, :"0")
		@color_tracker = [:light_black, :black]
		@offset = 0
	end

	def get_symbol_under_reader
		@current_square
	end

	def move_left_one_full
		3.times do
			move_left_one_third
			sleep(1)
		end
	end

	def move_right_one_full
		3.times do
			move_right_one_third
			sleep(1)
		end
	end

	def render
		system("clear")
		tape_string = build_tape_string
		5.times {puts}
		puts tape_string
		# renderleft(offset)
		# rendercurrent(offset)
		# renderright(offset)
		render_arrow
	end


	private

	def adjust_square_right
		@left = @left.unshift(@current_square)
		@current_square = @right.shift
		@right << :"0"
	end
	def adjust_square_left
		@right = @right.unshift(@current_square)
		@current_square = @left.shift
		@left << :"0"
	end

	def build_square(color, square_symbol = " ")
		square_array = []
		square_array << " ".colorize(background: color)
		square_array << "#{square_symbol}".colorize(background: color)
		square_array << " ".colorize(background: color)
		square_array
	end

	def build_tape_string
		string_array = []
		10.times do |idx|
			string_array += build_square(@color_tracker[0],@left[9-idx])
			@color_tracker.rotate!(1)
		end
		string_array += build_square(@color_tracker[0],@current_square)
		@color_tracker.rotate!(1)
		10.times do |idx|
			string_array += build_square(@color_tracker[0],@right[idx])
			@color_tracker.rotate!(1)
		end

		if @offset > 0
			(@offset).times {string_array.shift}
		elsif offset < 0
			extra_left_square = [" ".blue,"#{@left[10]}".blue," ".blue]
			(@offset*-1).times {|idx| string_array.unshift(extra_left_square.pop)} #needswork?
		end
		@color_tracker.rotate!(1)
		string_array.join("")
	end

	def move_right_one_third
		@offset +=1
		if @offset == 3
			@offset = 0
			adjust_square_right
			@color_tracker = @color_tracker.rotate
		end
		render
	end

	def move_left_one_third
		@offset +=-1
		if @offset == -3
			@offset = 0
			adjust_square_left
			@color_tracker = @color_tracker.rotate
		end
		render
	end

	def render_arrow
		31.times {print " "}
		print "^".blink
		puts
	end

end
