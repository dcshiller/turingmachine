require_relative "../fundamentals/window_organization.rb"

class Display
  include WinOrg
  attr_reader :tape
  attr_accessor :selection

  def initialize(tape, log)
    @tape = tape
    @tape_length = 10
    @log = log
    @selection = 1
  end

  def refresh_program_state(program_state)
    @program_state = program_state
  end

  def refresh_tape_length
    span = 0.4
    @tape_length = ((@cols/3)*span -1).to_i
  end

  def render_panels
    window = make_and_combine_panels
    window.draw_content
  end

  private
  attr_reader :tape_length

	def build_tape_array
		string_array = []
		(tape_length/2).times do |idx|
			string_array = [tape.left_spaces[idx].to_string_array] + string_array
		end
		string_array << tape.current_space.to_string_array
		(tape_length/2).times do |idx|
			string_array = string_array + [tape.right_spaces[idx].to_string_array]
		end
    string_array.flatten!
	end

  def arrow(direction)
    arrow = (direction == :up ? "\u25BC" : "\u25B2")
    adjustment = (tape_length+1)%2
    [(" " * ((tape_length*3)/2+adjustment) + arrow.encode("utf-8")).split("")]
  end


  def make_log_panel_content(height)
    log_content = @log.map.with_index {|el, idx| idx.to_s + " " + el}
    log_content.shift until log_content.length < height
    log_content.map {|el| [[el]]}
  end

  def make_tape_panel_content
    tape_panel_content = []
    1.times {tape_panel_content << [[""]]}
    tape_panel_content << arrow(:up)
    tape_array = build_tape_array
    tape_array = offset(tape_array, tape.offset )
    tape_panel_content << [tape_array]
    tape_panel_content << arrow(:down)
  end

  def make_info_panel_content
    info_panel_content = []
    1.times {info_panel_content << [[""]]}
    info_panel_content << [["Current State: " + @program_state.number_tag]]
    info_panel_content << [["  if x, then " + @program_state.get_behavior_as_string(:x)]]
    info_panel_content << [["        and go to " + @program_state.get_next_state(:x).number_tag]]
    info_panel_content << [["  if 0, then go to " + @program_state.get_behavior_as_string(:x)]]
    info_panel_content << [["        and go to " + @program_state.get_next_state(:"0").number_tag]]
    info_panel_content << [["Current Space: " + @tape.current_space.to_s]]
    # info_panel_content << [["Offset: #{tape.offset}"]]
  end

  def make_menu_panel_content
    menu_panel_content = []
    menu_panel_content << ["Set Arguments"]
    menu_panel_content << ["Start"]
    menu_panel_content << ["Restart"]
    menu_panel_content << ["Finish"]
    menu_panel_content << ["Load Program"]
    menu_panel_content[selection-1].red
    menu_panel_content
  end

  def make_and_combine_panels
    refresh_window_information and refresh_tape_length

    menu_panel = Panel.new(0.47,0.4,
                          make_menu_panel_content,
                          title: "Menu",
                          padded: true)

    tape_panel = Panel.new(0.47,0.4,
                          make_tape_panel_content,
                          title: "Tape Display",
                          padded: true)

    left_panel = menu_panel.place_on_top_of(tape_panel)

    margin = Panel.new(0.03,0.8,[[]], background_color: :light_black)

    left_panel = margin.place_side_by_side(left_panel)

    state_info_panel = Panel.new(0.47,0.5,
                          make_info_panel_content,
                          title: "State Information",
                          padded: true)

    log_panel = Panel.new(0.47,0.3,
                          make_log_panel_content(0.3*@rows),
                          title: "Log",
                          padded: true)

    info_panel = state_info_panel.place_on_top_of(log_panel)

    info_panel = info_panel.place_side_by_side(margin)
    central_panel = left_panel.place_side_by_side(info_panel)

    top_panel = Panel.new(1, 0.1, [[""]],
                          title: "Program Viewer",
                          background_color: :light_black)
    bottom_panel = Panel.new(1, 0.1, [[""]], background_color: :light_black)

    bottom_and_central_panel = central_panel.place_on_top_of(bottom_panel)
    top_panel.place_on_top_of(bottom_and_central_panel)
  end

  def offset(tape_array, offset_amount)
    if offset_amount > 0
      (offset_amount).times {tape_array.shift}
      extra_right_square = tape.right_spaces[tape_length/2].to_string_array
      (offset_amount).times {tape_array.push(extra_right_square.pop)}
    elsif offset_amount < 0
      (offset_amount*-1).times {tape_array.pop}
      extra_left_square = tape.left_spaces[tape_length/2].to_string_array
      (offset_amount*-1).times {tape_array.unshift(extra_left_square.pop)}
    end
    tape_array
  end

	# def up_arrow
  #   adjustment = (tape_length+1)%2
  #   [(" " * ((tape_length*3)/2 + adjustment) + "\u25B2".encode("utf-8")).split("")]
	# end
end
