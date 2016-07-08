# require 'colorize'

module WinOrg

  def center(string)
    length = string.uncolorize.length
    max_width = @panel_width || @cols
    " " * ((max_width - length) /2) + string + " " * ((max_width - length) /2)
  end

  def justify(string)
    length = string.uncolorize.length
    puts (" " * (@cols/3)) + string + (" " * (2*(@cols)/3-length + (1)))
  end

  def refresh_window_information
    @cols, @rows = `tput cols`.to_i, `tput lines`.to_i
    [@cols, @rows]
  end


  def full_screen_gets(query)
    refresh_window_information
    system("\printf '\ec' ")
    puts "\n" * ((@rows / 2) - 2)
    print " " * ((@cols - 10) /2) + query + ": "
    gets
  end

end
