require 'io/console'
require_relative 'tape'
require 'colorize'
require 'byebug'
require_relative 'program_reader'

class TuringSim

  OPTIONS = ["1. Watch Sample",
             "2. Edit/Write Program (t.b.added)",
             "3. Load Program (t.b.added)",
             "4. Exit"]

  def initialize
    set_terminal_settings and at_exit { reset_terminal_settings and system("clear") }
    splash
    options
  end

  private

  def center(string)
    length = string.uncolorize.length
    puts " " * ((@cols - length) /2) + string + " " * ((@cols - length) /2)
  end

  def get_keystroke
    STDIN.raw!
    key = STDIN.getc.chr
    STDIN.cooked!
    key
  end

  def justify(string)
    length = string.uncolorize.length
    puts (" " * (@cols/3)) + string + (" " * (2*(@cols)/3-length + (1)))
  end


  def options
    selection = -1
    loop do
      print_options(selection)
      next_key = get_keystroke
      if next_key == "\e" then next_key << STDIN.read_nonblock(3) rescue nil end
      if next_key == "\e" then next_key << STDIN.read_nonblock(2) rescue nil end
      sleep(0.2)
      case next_key
      when  "\e[A"
        selection -= 1 unless selection < 1
      when "\e[B"
        selection += 1 unless selection >= OPTIONS.length - 1
      when "\r", "\n"
        ProgramReader.new.run_program if selection == 0
        system("clear") and exit if selection == 3
      when "b"
        break
      else
      end
    end
  end

  def print_options(selection)
    refresh_window_information
    system("clear")
    puts "\n" * ((@rows / 2) - 2)
    OPTIONS.each_with_index do |option, idx|
      if idx == selection then justify selected option else justify option end
    end
  end

  def refresh_window_information
    @cols, @rows = `tput cols`.to_i, `tput lines`.to_i
  end

  def reset_terminal_settings
    system("setterm -cursor on")
    STDIN.echo = true
    STDIN.cooked!
    #system("clear")
  end

  def selected(string)
    string.red
  end

  def set_terminal_settings
    system("setterm -cursor off")
    STDIN.echo = false
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
    get_keystroke
  end

end


TuringSim.new
