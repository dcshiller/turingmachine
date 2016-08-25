# Turing Machine Simulator

See also the [User's Guide](USERGUIDE.md)

## Introduction

This is a Ruby terminal program designed to create and display Turing machines.

Turing machines are abstract computers invented by Alan Turing. A machine consists of a string of tape that is infinite in both directions and segmented into sections. Each section may be blank or contain a symbol. The machine is able to read the symbol at a specific position and then either write a different symbol, move the tape one space to the left or right, or stop running.

 A program for a Turing machine consists in a series of states that each describe the machines behavior given a certain input and direct the machine what state to move into next.

## Terminal Program

The program is designed to be run from the console in either Apple or Linux operating systems with Ruby installed. Download the program and navigate a console to the folder where 'turingsim.rb' is located. The program runs with the command "ruby turingsim.rb".

The Turing Machine Simulator produces a graphical user interface within the terminal using a custom panel system. The keyboard can be used to move between menu options and to build Turing machines.

## Navigation

The program links several different primary components through a central menu. The menu is implemented as a paired array of menu option strings and menu options procs.

![MainMenu]
[MainMenu]: ./docs/MainMenu.png

```ruby
MAIN_MENU_OPTIONS = [
  "What is a Turing Machine?",
  "Run Program",
  "Edit/Write Program",
  "Load Program",
  "Exit"
]

MAIN_MENU_EFFECTS = [
  Proc.new { introduction_info },
  Proc.new { ProgramReader.new.run_program },
  Proc.new { ProgramEditor.new },
  Proc.new { load_program },
  Proc.new { full_clear; exit}
]
```

## Panels

Individual displays are constructed using a custom module for building and combining colored panels. Each panel is an array of array of strings, so that individual strings can be assigned their own background and text colors. Individual features are provided through an options hash.

![ProgramDisplay]
[ProgramDisplay]: ./docs/ProgramDisplay.png

```ruby
  def place_on_top_of(second_panel)
    raise "Widths don't align" if self.width_percentage != second_panel.width_percentage
    Panel.new(
              width_percentage,
              height_percentage + second_panel.height_percentage,
              content + second_panel.content
              )
  end
  ```


```ruby
 state_list_panel = Panel.new(0.4, 0.8, left_panel_content,
                                title: "State Names".black,
                                background_color: :white,
                                padded: true)
```
Panels are directly added to each other with place_on_top_of and place_side_by_side methods. Margins are added as very slim colored panels.

Individual panels are updated as needed based on changes in input, avoiding the need for fully reconstructing the whole view each time the state of the machine changes.   

```ruby
def make_and_combine_panels
  refresh_window_information
  make_margins unless @margin
  make_menu_panel if @update[:menu]
  make_tape_panels if @update[:tape]
```

## Program Structure

The Turing machines themselves are implemented across three different classes. The abstract program details are saved in a MachineState class that records how the program will run on a given input. A instance of the MachineState class is a single node in the state-tree of the machine. From a given state, all downstream states can be recursively recovered.

```ruby
  def self.get_downstream_states(state, states = [])
    connected_states = MachineState.connected(state)
    return states if connected_states.all? {|state| states.include?(state)}
    states += connected_states
    states = states.uniq
    connected_states.each do |state|
      states += MachineState.get_downstream_states(state, states)}
    end
    states.uniq.sort {|a,b| a.number <=> b.number}
  end  
```

These machines do not track of the tape. For that, a tape class is used. The tape class is essentially built from three arrays representing the left spaces, space under the reader, and right spaces. The reader is moved by popping or shifting from the respective array into the current space and shuffling the prior current space onto the other array. This allows for an unlimited amount of memory.

The tape class is intimately connected with the user interface, and records the position of the tape with colorized strings. Though this surely could be done more efficiently, if it does not actually display the tape, the program can find the result fairly fast. Using its *finish* feature, it has been clocked to around 20,000 machine steps per second on a standard contemporary laptop.

```ruby
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

  ...

  def self.color(iteration)
    COLORS.rotate(iteration)[0]
  end
```

### Program Design

Programs can be accessed and modified from Program Editor.

![Editor]
[Editor]: ./docs/Editor.png

Editing toggles the settings of individual states, running through the available options by keypress. This program was not designed for making massive Turing machines.

```ruby
  def toggle_state_behavior
    behaviors = [:markx, :mark0, :right, :left, :halt]
    program = @program_states[@lselection]
    input = (@rselection % 4 <= 1) ? :x : :"0"
    go_to_state = program.get_next_state(input)

    current_behavior_number = behaviors.find_index(program.get_behavior(input))

    new_behavior_number = @rselection.even? ? ((current_behavior_number + 1) % 5) : current_behavior_number

```
