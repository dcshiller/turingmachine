

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
		print @current_square
	end

	def renderright
		10.times {|idx| print "[#{@right[idx]}]"}
		puts
	end


end
