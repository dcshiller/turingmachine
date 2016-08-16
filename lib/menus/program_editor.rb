require 'yaml'
require_relative '../fundamentals/window_organization'
require_relative '../fundamentals/array_colors'
require_relative '../machinelogic/machine_state'
require_relative '../fundamentals/key_input'
require_relative '../fundamentals/machine_writer'
require 'colorize'
require 'io/console'
require_relative 'panels'

class ProgramEditor
    include WinOrg, KeyInput, MachineWriter

  def initialize(program = MachineState.make_adder)
    # system("stty -echo"
    refresh_window_information
    @program = program
    @program_states = MachineState.get_downstream_states(@program)
    get_program_state_names


    @lselection, @rselection = 0, 0
    @focus = [:left,:right]

    @state_number, @state_if_x, @state_if_o = [""], ["", ""], ["", ""]
    @program_state_data = [@state_number,@state_if_x,@state_if_o]
    selection_loop
  end

  def left_panel_content
    num_rows = @rows * 0.8
    if @lselection >= num_rows -1
      return @program_state_names[(@lselection-num_rows+2)..@lselection+1]
    else
      @program_state_names
    end
  end

  def get_right_panel_colors(entry_number)
    if focus_left?
      :black
    else
      [:red, :black, :black, :black].rotate(-1*@rselection)[entry_number]
    end
  end

  def right_panel_process_text (text, entry_number)
    (text || " ").colorize(get_right_panel_colors(entry_number))
  end

  def right_panel_content
    return [[""], ["", ""], ["", ""]] if @program_states[@lselection] == nil
    state_info = @program_states[@lselection].get_state_information_hash

    @state_number[0] = (state_info["state_number"] || " ").black
    @state_if_x[0] = right_panel_process_text("Go " + state_info["input_x_behavior"], 0)
    @state_if_x[1] = right_panel_process_text(" and go to " + state_info["input_x_state"], 1)
    @state_if_o[0] = right_panel_process_text("Go " + state_info["input_o_behavior"], 2)
    @state_if_o[1] = right_panel_process_text(" and go to " + state_info["input_o_state"], 3)
    @program_state_data
  end

  def make_and_combine_panels
    top_panel = Panel.new(1, 0.1,[[]],
                                title: "Program Editing Menu",
                                background_color: :light_black,)

    margin = Panel.new(0.1,0.8,[[]], background_color: :light_black)

    state_list_panel = Panel.new(0.4, 0.8, left_panel_content,
                                title: "State Names".black,
                                background_color: :white,
                                padded: true)

    state_list_panel = margin.place_side_by_side(state_list_panel)

    state_innards_panel = Panel.new(0.4, 0.8,
                                right_panel_content[1..-1],
                                title: right_panel_content[0][0],
                                background_color: :light_white,
                                padded: true)

    state_innards_panel = state_innards_panel.place_side_by_side(margin)

    bottom_panel = Panel.new(1, 0.1,
                                [ [center("'s': save, 'l': load,  'enter': switch focus, 'spacebar': change setting")],
                                  [center("'new/enter': make a new state, 'm': return to menut")], ],
                                background_color: :light_black)

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

  def focus_right?
    !focus_left?
  end

  def get_program_state_names
    @program_state_names = @program_states.collect {|program_state| [program_state.number_tag].black}  + [["--> new".black]]
  end

  def save
    yaml_program_states = YAML.dump(@program_states)
    file_name = "./programs/" + full_screen_gets("File name:").chomp + ".tm"
    File.open(file_name, "w") do |file|
      file.write(yaml_program_states)
    end
    sleep(3)
  end

  def load
    load_program
    yaml_program_states = File.read(file_name)
    @program_states = YAML.load(yaml_program_states)
    get_program_state_names
  end

  def selection_loop
    loop do
       color_selection
       window = make_and_combine_panels
       full_clear
       system("setterm -cursor off")
       window.draw_content
       STDIN.echo = false
      case get_keystroke
      when "\r", "\n"
        if @lselection == @program_state_names.count - 1
          new_state = MachineState.new(@lselection+1)
          new_state.set_behavior(:x => [:halt, new_state], :"0" => [:halt, new_state])
          @program_states << new_state
          get_program_state_names
        end
        @rselection = 0
        @focus.rotate![1]
      when " "
        if focus_right?
          toggle_state_behavior
        end
      when "s"
        save
      when "l"
        load
      when "m"
        break
      when "\e[D"
        @rselection -= 1 unless @rselection.even?
      when "\e[C"
        @rselection += 1 unless @rselection.odd?
      when "\e[A"
        if focus_left?
          @lselection -= 1 unless @lselection <= 0
        else
          @rselection += 2
        end
      when "\e[B"
        if focus_left?
          @lselection += 1 unless @lselection >= (@program_states.count)
        else
          @rselection -= 2
        end
      else
      end
    end
  end

  def toggle_state_behavior
    behaviors = [:markx, :mark0, :right, :left, :halt]
    program = @program_states[@lselection]
    input = (@rselection % 4 <= 1) ? :x : :"0"
    go_to_state = program.get_next_state(input)

    current_behavior_number = behaviors.find_index(program.get_behavior(input))

    new_behavior_number = @rselection.even? ? ((current_behavior_number + 1) % 5) : current_behavior_number

    current_state_number = @program_states.find_index(go_to_state)
    if @rselection.odd? && current_state_number <= @program_states.count-2
      go_to_state = @program_states[current_state_number + 1]
    elsif @rselection.odd?
      go_to_state = @program_states[0]
    end
    program.set_behavior(input => [behaviors[new_behavior_number], go_to_state])
  end

end
