
require_relative 'window_organization'
require_relative '../machine_state'
require_relative '../key_input'
require 'colorize'
require 'io/console'
require_relative 'panels'

class ProgramEditor
    include WinOrg, KeyInput

  def initialize(program = MachineState.make_adder)
    refresh_window_information
    @program = program

    @lselection = -1
    @rselection = 0
    @focus = [:left,:right]
    @program_state_names = get_program_state_names(@program)

    @state_number = [""]
    # @state_if_x_do_y, @state_if_x_then_go_to = "", ""
    # @state_if_x = [@state_if_x_do_y, @state_if_x_then_go_to]
    @state_if_x = ["", ""]
    # @state_if_o_do_y, @state_if_o_then_go_to = "", ""
    # @state_if_o = [@state_if_o_do_y, @state_if_o_then_go_to]
    @state_if_o = ["", ""]
    @program_state_data = [@state_number,@state_if_x,@state_if_o]
    selection_loop
  end

  def left_panel_content
    @program_state_names + [[[""]],[["new".black]]]
  end

  def right_panel_content
      state_info = @program.get_state_information_hash(@lselection)
      text_colors = focus_left? ? Array.new(4,:black) : [:red, :black, :black, :black].rotate(-1*@rselection)
      @state_number[0] = (state_info["state_number"] || " ").black
      @state_if_x[0] = ("Do " + state_info["input_x_behavior"] || " ").colorize(text_colors[0])
      @state_if_x[1] = (" and go to " + state_info["input_x_state"] || " ").colorize(text_colors[1])
      @state_if_o[0] = ("Do " + state_info["input_o_behavior"] || " ").colorize(text_colors[2])
      @state_if_o[1] = (" and go to " + state_info["input_o_state"] || " ").colorize(text_colors[3])
      @program_state_data
  end

  def make_and_combine_panels
    top_panel = Panel.new(1, 0.1,[[],[center("Program Editing Menu")]], :light_black)

    state_list_panel = Panel.new(0.7, 0.8, left_panel_content, :white)
    state_innards_panel = Panel.new(0.3, 0.8, right_panel_content, :light_white)

    bottom_panel = Panel.new(1, 0.1, [[""]], :light_black)

    middle_panels = state_list_panel.place_side_by_side(state_innards_panel)
    top_and_middle_panels = top_panel.place_on_top_of(middle_panels)

    top_and_middle_panels.place_on_top_of(bottom_panel)
  end

  def color_selection
    if focus_left?
      @program_state_names[@lselection-1][0] = @program_state_names[@lselection-1][0].black if @program_state_names[@lselection-1]
      @program_state_names[@lselection+1][0] = @program_state_names[@lselection+1][0].black if @program_state_names[@lselection+1]
      @program_state_names[@lselection][0] = @program_state_names[@lselection][0].red if @lselection >= 0 && @program_state_names[@lselection]
    else
      @program_state_names[@lselection][0] = @program_state_names[@lselection][0].blue if @lselection >= 0 && @program_state_names[@lselection]
    end
  end

  def focus_left?
    @focus.first == :left
  end

  def get_program_state_names(program)
    MachineState.get_downstream_states(program).collect {|program_state| [program_state.number_tag.black]}
  end

  def selection_loop
    loop do
       color_selection
       window = make_and_combine_panels
       system("clear")
       window.draw_content
      case get_keystroke
      when "\r", "\n"
        @focus.rotate![1]
      when " "
        behaviors = [:markx, :mark0, :right, :left]
        program = MachineState.get_downstream_states(@program).select {|program| program.number_tag == @program_state_names[@lselection][0].uncolorize}.first
        input = :x if @rselection < 3
        input = :"0" if @rselection > 2
        go_to_state = program.get_next_state(input)
        current_behavior_number = behaviors.find_index(program.get_behavior(input))
        new_behavior_number = @rselection.even? ? ((current_behavior_number + 1) % 4) : current_behavior_number
        states = MachineState.get_downstream_states(@program)
        current_state_number = states.find_index(go_to_state)
        go_to_state = states[current_state_number+1] if @rselection.odd?
        # debugger
        program.set_behavior(input => [behaviors[new_behavior_number], go_to_state])
      when "\e[D"
        @rselection -= 1 unless @rselection.even?
      when "\e[C"
        @rselection += 1 unless @rselection.odd?
      when "\e[A"
        if focus_left?
          @lselection -= 1 unless @lselection < 0
        else
          @rselection += 2
        end
      when "\e[B"
        if focus_left?
          @lselection += 1 unless @lselection >= (@program.count + 1)
        else
          @rselection -= 2
        end
      when "b"
        break
      else
      end
    end
  end

end

ProgramEditor.new
