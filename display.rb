require 'byebug'


class Display

  attr_reader :tape

  def initialize(tape)
    @tape = tape
  end

  def render(state)
    tape_array = build_tape_array
    tape_string = offset(tape_array, tape.offset).join("")
    system("clear")
    puts "\n\n\n\n\n"
    render_down_arrow
    puts tape_string
    render_up_arrow
    puts "\n\n\n\n\n"
    puts state.to_s
    puts @tape.current_space
    puts "Offset: #{tape.offset}"
  end

	def build_tape_array
		string_array = []
		10.times do |idx|
			string_array = [tape.left_spaces[idx].to_string_array] + string_array
		end
		string_array << tape.current_space.to_string_array
		10.times do |idx|
			string_array = string_array + [tape.right_spaces[idx].to_string_array]
		end
    string_array.flatten!
	end

  def offset(tape_array, offset_amount)
    if offset_amount > 0
      (offset_amount).times {tape_array.shift}
    elsif offset_amount < 0
      #(offset_amount).times {}
      extra_left_square = [" ".blue, ":0".blue, " ".blue]
      (offset_amount*-1).times {tape_array.unshift(extra_left_square.pop)} #needswork?
    end
    #  string_array.join("")
    tape_array
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
