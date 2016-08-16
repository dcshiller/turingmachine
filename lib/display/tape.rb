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

	def get_summary
		left_args = @left.collect {|space| space.read_mark}
		left_args = left_args.join("").split('0')
		left_args = left_args.collect {|arg_sequence| arg_sequence.length}
		left_args.unshift(0)
		right_args = @right.collect {|space| space.read_mark}
		right_args = right_args.join("").split('0')
		right_args = right_args.collect {|arg_sequence| arg_sequence.length}
		if @current_space.read_mark == :x
			right_args[0] = (right_args[0] || 0) + (left_args.pop || 0) + 1
		end
		all_args = left_args.concat(right_args)
		all_args.delete(0)
		all_args.join(",")# if all_args
	end

	def get_mark_under_reader
		current_space.read_mark
	end

	def move_one_full(direction)
		to,from = (direction == :right ? [@right,@left] : [@left,@right])
		from = from.unshift(@current_space)
		@current_space = to.shift
		to << Space.new
	end

	def offset_to(direction)
		@offset += (direction == :right ? 1 : -1)
		if @offset > 2 || @offset < -2
			@offset = 0
			move_one_full(direction)
		end
	end

	def self.color(iteration)
		COLORS.rotate(iteration)[0]
	end

	def write_mark(new_mark)
		current_space.write_mark(new_mark)
	end

	private

end
