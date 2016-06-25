require 'colorize'
require_relative 'space'

class Tape
	attr_reader :left, :right, :current_space, :offset
	alias  :left_spaces :left
	alias :right_spaces :right
	COLORS = [:black, :light_black]

	def initialize(*arguments)
		@left = Array.new(15) {|idx| Space.new(color(idx))}
		@current_space = Space.new(color(1), :x)
		arguments = arguments.collect.with_index {|mark, idx| Space.new(color(idx), mark) }
		@right = arguments + Array.new(15) {|idx| Space.new(color(idx))}
		@offset = 0
	end

	def color(iteration)
		COLORS.rotate(iteration)[0]
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
			idx == 2 ? sleep(0.5) : sleep(.1)
		end
	end

	def move_right_one_full
		3.times do |idx|
			move_right_one_third
			idx == 2 ? sleep(0.5) : sleep(.1)
		end
	end

	private

	def adjust_space_right
		@left = @left.unshift(@current_space)
		@current_space = @right.shift
		@right << Space.new #TODO add colors
	end
	def adjust_space_left
		@right = @right.unshift(@current_space)
		@current_space = @left.shift
		@left << Space.new
	end

	def move_right_one_third
		@offset +=1
		puts @offset
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
