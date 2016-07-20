# require 'colorize'
module WinOrg

  def center(string)
    length = string.uncolorize.length
    max_width = @panel_width || @cols
    " " * ((max_width - length) /2) + string + " " * ((max_width - length) /2)
  end

  def flash(notice)
    refresh_window_information
    full_clear
    # system("\printf '\ec' ")
    puts "\n" * ((@rows / 2) - 2)
    print " " * ((@cols - 10) /2) + notice + " "
    sleep(1)
  end

  def full_clear
    # system("printf '\33c\e[3J'")
    # system("\printf '\ec' ")
    system("clear")
  end

  def full_screen_gets(query)
    refresh_window_information
    full_clear
    puts "\n" * ((@rows / 2) - 2)
    print " " * ((@cols - 10) /2) + query + " "
    gets
  end

  def justify(string, offset = 10)
    length = string.uncolorize.length
    debugger if offset.is_a?(String)
    before_length = ((@cols/2) - offset)
    before_space = " " * before_length
    puts (before_space + string )# + (" " * (2*(@cols)/-10-length + (1)))
  end

  def refresh_window_information
    @cols, @rows = `tput cols`.to_i, `tput lines`.to_i
    [@cols, @rows]
  end


end
