require 'colorize'
require_relative 'space'

class Tape
	attr_reader :left, :right, :current_space, :offset
	alias  :left_spaces :left
	alias :right_spaces :right

	def initialize(arguments = Array.new {Space.new})
		@left = Array.new(15, Space.new)
		@first_space = Space.new(:red,:x)
		@current_space = @first_space
		@right = arguments + Array.new(15, Space.new)
		@offset = 0
	end

	def write_mark(new_mark)
		current_space.write_mark(new_mark)
	end

	def get_mark_under_reader
		current_space.read_mark
	end

	def move_left_one_full
		3.times do |idx|
			move_left_one_third
			sleep(0.1)
			sleep(0.5) if idx == 2
		end
	end

	def move_right_one_full
		3.times do |idx|
			move_right_one_third
			sleep(0.1)
			sleep(0.5) if idx == 2
		end
	end

	private

	def adjust_space_right
		@left = @left.unshift(@current_space)
		@current_space = @right.shift
		@right << Space.new
	end
	def adjust_space_left
		@right = @right.unshift(@current_space)
		@current_space = @left.shift
		@left << Space.new
	end

	def move_right_one_third
		@offset +=1
		if @offset == 3
			@offset = 0
			adjust_space_right
		end
	end

	def move_left_one_third
		@offset +=-1
		if @offset == -3
			@offset = 0
			adjust_space_left
		end
	end
end
