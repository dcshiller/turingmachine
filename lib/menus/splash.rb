require_relative '../fundamentals/window_organization'
require_relative '../fundamentals/key_input'
  def splash
    refresh_window_information
    full_clear #
    puts "\n" * ((@rows / 2) - 2)
    title = "Turing Machine Simulator".split("")
    title = title.collect.with_index {|mark, idx| Space.new(Tape.color(idx), mark) }
    puts " " * ((@cols - title.length*3) /2) + title.join("") + " " * ((@cols - title.length*3) /2)
    puts center( "Derek Shiller (2016)")
    get_keystroke
  end
