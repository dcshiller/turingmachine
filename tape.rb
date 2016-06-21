require 'colorize'

class Tape
	attr_reader :left, :right, :current_square, :offset

	def initialize
		@left = Array.new(15, :"0")
		@current_square = :"x"
		@right = Array.new(15, :"0")
		@color_tracker = [:light_black, :black]
		@offset = 0
	end

	def render
		system("clear")
		tape_string = build_tape_string
		puts tape_string
		# renderleft(offset)
		# rendercurrent(offset)
		# renderright(offset)
		render_arrow
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
		#string_array = string_array.drop(offset)

		(@offset).times {string_array.shift}
		# cut_off_length = string_array.length - 63
		# cut_off_excess = cut_off_length % 2
		#mi  string_array = string_array.drop(offset)
		# string_array = string_array.take(string_array.length - (cut_off_length/2))
		@color_tracker.rotate!(1)
		string_array.join("")
	end
	#
	# def renderleft(offset = 0)
	# 	case offset
	# 	when -1
	# 		print "#{@left[0]}".colorize(background: :light_black)
	# 	when 0
	# 		print "|#{@left[0]}".colorize(background: :light_black)
	# 	end
	# 	9.times {|idx| print "|#{@left[idx+1]}".colorize(background: :light_black)}
	# end
	#
	# def rendercurrent(offset = 0)
	# 	case offset
	# 	when -1
	# 	  print "|".colorize(background: :light_black) + "#{@current_square}".red.colorize(background: :light_black) +"|".colorize(background: :light_black)
	# 	when 0
	# 		print "|".colorize(background: :light_black) + "#{@current_square}".red.colorize(background: :light_black)
	# 	when 1
	# 		print "|#{@current_square}|".red.colorize(background: :light_black)
	# 	end
	# end
	#
	# def renderright(offset = 0)
	# 	case offset
	# 	when -1
	# 		print "#{@right[0]}".colorize(background: :light_black)
	# 	when 0
	# 		print "|#{@right[0]}".colorize(background: :light_black)
	# 	when 1
	# 		print "#{@current_square}|#{@right[0]}".colorize(background: :light_black)
	# 	end
	# 	9.times {|idx| print "|#{@right[idx+1]}".colorize(background: :light_black)}
	# 	puts "|".colorize(background: :light_black)
	# end

	def render_arrow
		31.times {print " "}
		print "^".blink
		puts
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

	def adjust_square_right
		@left = @left.unshift(@current_square)
		@current_square = @right.shift
		@right << :"0"
	end

	def move_left
		@color_tracker.rotate
		3.times {|idx| sleep(1); render}
		@left << @current_square
		@current_square = @right.shift
		@right << :"0"

	end

	def move_right
		@right.unshift @current_square
		@current_square = @left.pop
		@left.unshift :"0"
	end

	def change_mark(new_mark)
		@current_square = new_mark
	end
end
