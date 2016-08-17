# require_relative 'window_organization'
require 'colorize'
require 'byebug'

class Panel
  include WinOrg
  attr_reader :cols, :rows, :panel_width, :panel_height, :content, :width_percentage, :height_percentage

  def initialize(width_percentage, height_percentage, content, options = {}) #Options: title = nil, background_color = nil, padded = false)
    refresh_window_information
    @width_percentage, @height_percentage = width_percentage, height_percentage
    @panel_width, @panel_height = @cols * width_percentage, @rows * height_percentage
    @content = content.dup

    pad_content if options[:padded]
    @content.unshift([center(options[:title])]) if options[:title]
    @background_color = options[:background_color] if options[:background_color]

    make_content_fit
    colorize_content
  end

  def add_rows_to_reach_height
    (panel_height - content.count).to_i.times { content << []}
  end

  def colorize_content
    content.collect! {|line| [line.join("").colorize(background: @background_color)]} if @background_color
  end

  def draw_content
    joined_content = content.collect {|con| con.join("")}.join("")
    full_clear
    puts joined_content
  end

  def extra_space_if_needed(first_panel, second_panel)
    if (@cols * first_panel.width_percentage).to_i + (@cols*second_panel.width_percentage).to_i <
            @cols * (first_panel.width_percentage + second_panel.width_percentage)
       [[" "]]
     else
       [[]]
     end
  end

  def make_content_fit
    subtract_rows_to_height
    add_rows_to_reach_height
    content.collect!.with_index {|row,row_number| fill_in_row_to_reach_width(row_number)}
  end

  def pad_content
    @content.collect!.with_index {|el,idx| [[" "] + el] }
  end

  def subtract_rows_to_height
    @content = @content[0...@panel_height]
  end

  def fill_in_row_to_reach_width(row_number)
    row_content = @content[row_number].join("")
    row_length = row_content.uncolorize.length
    [row_content + " "*([@panel_width - row_length,0].max)]
  end

  def padded?
    @padded
  end

  def place_on_top_of(second_panel)
    raise "Widths don't align" if self.width_percentage != second_panel.width_percentage
    Panel.new(
              width_percentage,
              height_percentage + second_panel.height_percentage,
              content + second_panel.content
              )
  end

  def place_side_by_side(second_panel)
    raise "Heights must align" if self.height_percentage != second_panel.height_percentage
    extra_space = extra_space_if_needed(self, second_panel)
    
    if (@cols * self.width_percentage).to_i + (@cols*second_panel.width_percentage).to_i <
       @cols * (self.width_percentage + second_panel.width_percentage)
       extra_space = [[" "]]
     else
       extra_space = [[]]
     end

    merged_content = content.collect.with_index {|line, index| line + extra_space + second_panel.content[index]}
    Panel.new(
              width_percentage + second_panel.width_percentage,
              height_percentage,
              merged_content
              )
  end

  def place_on_top_of(second_panel)
    raise "Widths don't align" if self.width_percentage != second_panel.width_percentage
    Panel.new(
              width_percentage,
              height_percentage + second_panel.height_percentage,
              content + second_panel.content
              )
  end
end
