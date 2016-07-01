
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

    @program_state_names = get_program_state_names(@program)

    @state_number = [""]
    @state_if_x_do_y = ""
    @state_if_x_then_go_to = ""
    @state_if_x = [@state_if_x_do_y, @state_if_x_then_go_to]
    @state_if_o_do_y = [""]
    @state_if_o_then_go_to = [""]
    @program_state_data = [@state_number,@state_if_x,@state_if_o_do_y]
    selection_loop
  end

  def left_panel_content
    @program_state_names + [[[""]],[["new".black]]]
  end

  def right_panel_content
    state_info = @program.get_state_information(@lselection)
    state_info = state_info.split(" ")
    @state_number[0] = (state_info[0] || " ").black
    @state_if_x[0] = (state_info[1] || " ").black + " "
    @state_if_x[1] = (state_info[2] || " ").black
    @state_if_o_do_y[0] = ((state_info[3] || " ") + (state_info[4] || " "))[0...-1].black
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
    @program_state_names[@lselection-1][0] = @program_state_names[@lselection-1][0].black if @program_state_names[@lselection-1]
    @program_state_names[@lselection+1][0] = @program_state_names[@lselection+1][0].black if @program_state_names[@lselection+1]
    @program_state_names[@lselection][0] = @program_state_names[@lselection][0].red if @lselection >= 0 && @program_state_names[@lselection]
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
      when "\e[C"
      when "\e[A"
        @lselection -= 1 unless @lselection < 1
      when "\e[B"
        @lselection += 1 unless @lselection >= (@program.count + 1 )
      when "\r", "\n"
        effects[@lselection].call
      when "b"
        break
      else
      end
    end
  end

end

ProgramEditor.new
