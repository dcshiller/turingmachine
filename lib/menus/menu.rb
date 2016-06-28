require_relative 'window_organization'
require_relative '../key_input'
require 'singleton'

class Menu
  include WinOrg, KeyInput, Singleton

  def initialize(options, effects)
   selection = -1
   loop do
     print_menu_options(options, selection)
     next_key = get_keystroke
     if next_key == "\e" then next_key << STDIN.read_nonblock(3) rescue nil end
     if next_key == "\e" then next_key << STDIN.read_nonblock(2) rescue nil end
     sleep(0.2)
     case next_key
     when  "\e[A"
       selection -= 1 unless selection < 1
     when "\e[B"
       selection += 1 unless selection >= options.length - 1
     when "\r", "\n"
       effects[selection].call
     when "b"
       break
     else
     end
   end
  end

  def print_menu_options(options, selection)
    refresh_window_information
    system("clear")
    puts "\n" * ((@rows / 2) - 7)
    puts center("Turing Machine Simulator\n\n")
    options.each_with_index do |option, idx|
     if idx == selection then justify selected option else justify option end
    end
  end

  def selected(string)
    string.red
  end
end
