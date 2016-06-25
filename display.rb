
class Display

  attr_reader :tape

  def initialize(tape)
    @tape = tape
  end

  def render
    tape_string = build_tape_string
    system("clear")
    puts "\n\n\n\n\n"
    render_down_arrow
    puts tape_string
    render_up_arrow
    puts "\n\n\n\n\n"
  end

	def build_tape_string
		string_array = []
		10.times do |idx|
			string_array.unshift(tape.left_spaces[idx].to_s)
		end
		string_array << tape.current_space.to_s
		10.times do |idx|
			string_array << tape.right_spaces[idx].to_s
		end

    offset = tape.offset

    if offset > 0
			(offset).times {string_array.shift}
		elsif offset < 0
			extra_left_square = [" ".blue,"#{@left[10]}".blue," ".blue]
			(offset*-1).times {|idx| string_array.unshift(extra_left_square.pop)} #needswork?
		end
		string_array.join("")
	end

	def render_down_arrow
		31.times {print " "}
		print "\u25BC".encode("utf-8")
		puts
	end

	def render_up_arrow
		31.times {print " "}
		print "\u25B2".encode("utf-8")
		puts
	end
end
