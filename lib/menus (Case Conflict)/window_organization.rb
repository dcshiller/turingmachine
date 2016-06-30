module WinOrg

  def center(string)
    length = string.uncolorize.length
    puts " " * ((@cols - length) /2) + string + " " * ((@cols - length) /2)
  end

  def justify(string)
    length = string.uncolorize.length
    puts (" " * (@cols/3)) + string + (" " * (2*(@cols)/3-length + (1)))
  end

  def refresh_window_information
    @cols, @rows = `tput cols`.to_i, `tput lines`.to_i
    [@cols, @rows]
  end

end
