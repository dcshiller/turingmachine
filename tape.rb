require 'colorize'
require_relative 'space'

class Tape
	attr_reader :left, :right, :current_space
	attr_accessor :offset
	alias  :left_spaces :left
	alias :right_spaces :right
	COLORS = [:black, :light_black]

	def initialize(*arguments)
		@left = Array.new(15) {|idx| Space.new(color(idx))}
		@current_space = Space.new(color(1), arguments.shift)
		arguments = arguments.collect.with_index {|mark, idx| Space.new(color(idx), mark) }
		@right = arguments + Array.new(15) {|idx| Space.new(color(idx % 2+1))}
		@offset = 0
	end

	def color(iteration)
		COLORS.rotate(iteration)[0]
	end

	def write_mark(new_mark)
		current_space.write_mark(new_mark)
	end

	def offset_right
		@offset += 1
		if @offset > 2
			@offset = 0
			move_right_one_full
		end
	end

	def offset_left
		@offset -= 1
		if @offset < -2
			@offset = 0
			move_left_one_full
		end
	end

	def get_mark_under_reader
		current_space.read_mark
	end

	def move_left_one_full
		@right = @right.unshift(@current_space)
		@current_space = @left.shift
		@left << Space.new
	end

	def move_right_one_full
		@left = @left.unshift(@current_space)
		@current_space = @right.shift
		@right << Space.new #TODO add colors
	end

	private
	
end
