require_relative '../fundamentals/window_organization'
require_relative '../fundamentals/key_input'

  def introduction_info
    refresh_window_information
    full_clear

    content_panel = Panel.new(0.34,0.8,
                      info,
                      title: "What is a Turing machine?",
                      padded: true)
    margin_panel = Panel.new(0.33,0.8,[[""]])
    top_margin = Panel.new(1,0.2,[[""]])

    left_half = margin_panel.place_side_by_side(content_panel)
    full_window = left_half.place_side_by_side(margin_panel)
    full_window = top_margin.place_on_top_of(full_window)
    full_window.draw_content

    get_keystroke
  end

  def info
    text_width = refresh_window_information[0]/3
    words = "This is a ruby terminal program designed to create and display Turing machines. \n
    Turing machines are abstract computers invented by Alan Turing. A machine consists of a string of tape that is infinite in both directions and segmented into sections. Each section may be blank or contain a symbol. The machine is able to read the symbol at a specific position and then either write a different symbol, move the tape one space to the left or right, or stop running. \n
    A program for a Turing machine consists in a series of states that each describe the machines behavior given a certain input and direct the machine what state to move into next. \n
    ".split(" ")
    words = "This is a ruby terminal program designed to create and display Turing machines.".split(" ") if text_width < 30;

    lines, line = [[""],[""],[""]], ""

    while words.length > 0
      while words.length > 0 && line.length + words[0].length < text_width
        line += words.shift + " "
      end
      lines << [line]
      lines << [""] if text_width > 50
      line = ""
    end
    lines
  end
