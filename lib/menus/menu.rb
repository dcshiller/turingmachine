require_relative 'window_organization'
require_relative '../key_input'
require 'singleton'

class Menu
  include WinOrg, KeyInput, Singleton
  attr_reader :options, :effects
  attr_accessor :selection

  def initialize(selection, effects, title)
   @selection = -1
   @options, @effects = selection,effects
   @menu_title = title
   selection_loop
  end

  def selection_loop
    loop do
      print_menu_options
      case get_keystroke
      when  "\e[A"
        @selection -= 1 unless @selection < 1
      when "\e[B"
        @selection += 1 unless @selection >= options.length - 1
      when "\r", "\n"
        self.instance_eval effects[selection]
      when "b"
        break
      else
      end
    end
  end

  def max_length(array)
    sorted_array = array.sort do |option, option2|
      option.uncolorize.length <=> option2.uncolorize.length
    end
    sorted_array.last.length
  end

  def print_menu_options
    refresh_window_information
    full_clear#work for linux?
    offset = max_length(@options)/2
    puts "\n" * ((@rows / 2) - 7)
    puts center("#{@menu_title}\n\n")
    @options.each_with_index do |option, idx|
     if idx == @selection
        justify(selected(option), offset)
     else
       justify option, offset
     end
    end
  end

  def selected(string)
    string.red
  end
end
