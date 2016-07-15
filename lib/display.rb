require_relative "menus/window_organization.rb"

class Display
  include WinOrg

  attr_reader :tape

  def initialize(tape)
    @tape = tape
  end

  def refresh_program_state(program_state)
    @program_state = program_state
  end

  def make_tape_panel_content
    tape_panel_content = []
    3.times {tape_panel_content << [["\n"]]}
    tape_panel_content << down_arrow
    tape_array = build_tape_array
    tape_array = offset(tape_array, tape.offset)
    tape_panel_content << [tape_array]
    tape_panel_content << up_arrow
  end

  def make_info_panel_content
    info_panel_content = []
    3.times {info_panel_content << [["\n"]]}
    info_panel_content << [[@program_state.to_s]]
    info_panel_content << [[@tape.current_space]]
    info_panel_content << [["Offset: #{tape.offset}"]]
  end

  def make_and_combine_panels
    refresh_window_information
    tape_panel = Panel.new(0.5,0.5, make_tape_panel_content, "Tape Display")
    info_panel = Panel.new(0.5,0.5, make_info_panel_content, "State Information")
    top_panel = Panel.new(1, 0.1, [[""]], "Program Viewer", :black)
    bottom_panel = Panel.new(1, 0.1, [[""]])
    central_panel = tape_panel.place_side_by_side(info_panel)
    bottom_and_central_panel = central_panel.place_on_top_of(bottom_panel)
    top_panel.place_on_top_of(bottom_and_central_panel)
  end

  def render_panels
    window = make_and_combine_panels
    window.draw_content
  end

  # def render(state)
  #   tape_array = build_tape_array
  #   tape_string = offset(tape_array, tape.offset).join("")
  #   full_clear
  #   puts "\n\n\n\n\n"
  #   render_down_arrow
  #   puts tape_string
  #   render_up_arrow
  #   puts "\n\n\n\n\n"
  #   puts state.to_s
  #   puts @tape.current_space
  #   puts "Offset: #{tape.offset}"
  # end

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
    tape_array
  end

	def down_arrow
		[(" " * 31 + "\u25BC".encode("utf-8")).split("")]
	end

	def up_arrow
    [(" " * 31 + "\u25B2".encode("utf-8")).split("")]
	end
end
