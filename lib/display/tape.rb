require 'colorize'
require_relative 'space'

class Tape
	attr_reader :left, :right, :current_space
	attr_accessor :offset
	alias  :left_spaces :left
	alias :right_spaces :right
	COLORS = [:light_white, :light_black]

	def initialize(*arguments)
		@length = 40
		@left = Array.new(@length) {|idx| Space.new(Tape.color(idx))}
		@current_space = Space.new(Tape.color(1), arguments.shift)
		arguments << :"0" if arguments.length.even?
		arguments.collect!.with_index {|mark, idx| Space.new(Tape.color(idx), mark)}
		@right = arguments + Array.new(@length) {|idx| Space.new(Tape.color(idx % 2+1))}
		@offset = 0
	end

	def self.color(iteration)
		COLORS.rotate(iteration)[0]
	end

	def write_mark(new_mark)
		current_space.write_mark(new_mark)
	end

	def offset_to(direction)
		@offset += (direction == :right ? 1 : -1)
		if @offset > 2 || @offset < -2
			@offset = 0
			move_one_full(direction)
		end
	end
	#
	# def offset_left
	# 	@offset -= 1
	# 	if @offset < -2
	# 		@offset = 0
	# 		move_left_one_full
	# 	end
	# end

	def get_mark_under_reader
		current_space.read_mark
	end

	def move_one_full(direction)
		to,from = (direction == :right ? [@right,@left] : [@left,@right])
		from = from.unshift(@current_space)
		@current_space = to.shift
		to << Space.new
	end
	#
	# def move_right_one_full
	# 	@left = @left.unshift(@current_space)
	# 	@current_space = @right.shift
	# 	@right << Space.new #TODO add colors
	# end

	private

end
