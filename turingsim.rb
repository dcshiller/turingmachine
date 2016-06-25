require 'io/console'
require_relative 'tape'
require 'colorize'

class TuringSim

  def initialize
    system("setterm -cursor off")
    STDIN.raw!
    STDIN.echo = false
    at_exit do
      system("clear")
      system("setterm -cursor on")
      STDIN.echo = true
      STDIN.cooked!
    end
    splash
    options
  end

  def refresh_window_information
    @cols, @rows = `tput cols`.to_i, `tput lines`.to_i
  end

  def splash
    refresh_window_information
    system("clear")
    puts "\n" * ((@rows / 2) - 2)
    title = "Turing Machine Simulator".split("")
    title = title.collect.with_index {|mark, idx| Space.new(Tape.color(idx), mark) }
    puts " " * ((@cols - title.length*3) /2) + title.join("") + " " * ((@cols - title.length*3) /2)
    center( "Derek Shiller (2016)")
    #puts "\n" * (@rows / 2)
    STDIN.getc.chr
  end

  def center(string)
    length = string.uncolorize.length
    puts " " * ((@cols - length) /2) + string + " " * ((@cols - length) /2)
  end

  def justify(string)
    length = string.uncolorize.length
    puts (" " * (@cols/3)) + string + (" " * (2*(@cols)/3-length + (1)))
  end

  def options
    STDIN.raw!
    STDIN.echo = false
    selection = -1
    loop do
      refresh_window_information
      system("clear")
      puts "\n" * ((@rows / 2) - 2)
      print_options(selection)
      next_key = STDIN.getc.chr
      if next_key == "\e" then next_key << STDIN.read_nonblock(3) rescue nil end
      sleep(0.2)
      case next_key
      when  "\e[A"
        selection -= 1 unless selection < 1
      when "\e[B"
        selection += 1 unless selection > 1
      when "b"
        break
      else
        puts next_key
      end
    end
  end

  def print_options(selection)
    options = ["1. Watch Sample",
               "2. Edit/Write Program",
               "3. Load Program"]
    options.each_with_index do |option, idx|
      if idx == selection then justify selected option else justify option end
    end
  end

  def selected(string)
    string.red
  end

end


TuringSim.new
