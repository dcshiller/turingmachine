require 'colorize'

class Tape

	def initialize
		@left = Array.new(10, :"0")
		@current_square = :"0"
		@right = Array.new(10, :"0")
	end

	def render
		renderleft
		rendercurrent
		renderright
	end

	def renderleft
		10.times {|idx| print "[#{@left[idx]}]"}
	end

	def rendercurrent
		print "[#{@current_square}]".red
	end

	def renderright
		10.times {|idx| print "[#{@right[idx]}]"}
		puts
	end


	def move_left
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

