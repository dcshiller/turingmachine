
module Splash

  def splash
    refresh_window_information
    system("clear")
    puts "\n" * ((@rows / 2) - 2)
    title = "Turing Machine Simulator".split("")
    title = title.collect.with_index {|mark, idx| Space.new(Tape.color(idx), mark) }
    puts " " * ((@cols - title.length*3) /2) + title.join("") + " " * ((@cols - title.length*3) /2)
    center( "Derek Shiller (2016)")
    #puts "\n" * (@rows / 2)
    get_keystroke
  end

end
