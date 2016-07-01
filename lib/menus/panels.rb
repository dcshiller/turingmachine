require_relative 'window_organization'
require 'colorize'
require 'byebug'

class Panel
  include WinOrg
  attr_reader :cols, :rows, :panel_width, :panel_height, :content, :width_percentage, :height_percentage

  def initialize(width_percentage, height_percentage, content, background_color = nil)
    refresh_window_information
    @width_percentage = width_percentage
    @height_percentage = height_percentage
    @panel_width = @cols * width_percentage
    @panel_height = @rows * height_percentage
    @content = content
    @background_color = background_color
    make_content_fit
    colorize_content
  end

  def make_content_fit
    subtract_rows_to_height
    add_rows_to_reach_height
    content.collect!.with_index {|row,row_number| fill_in_row_to_reach_width(row_number)}
  end

  def subtract_rows_to_height
    @content = @content[0...@panel_height]
  end

  def add_rows_to_reach_height
    (panel_height - content.count).to_i.times { content << []}
  end

  def fill_in_row_to_reach_width(row_number)
    row_content = @content[row_number].join("")
    row_length = row_content.uncolorize.length
    debugger if @panel_width < row_length
    [row_content + " "*(@panel_width - row_length)]
  end

  def colorize_content
    content.collect! {|line| [line.join("").colorize(background: @background_color)]} if @background_color
  end

  def draw_content
    system("clear")
    content.each {|line| puts line.join("")}
  end

  def place_side_by_side(second_panel)
    merged_content = content.collect.with_index {|line, index| debugger if second_panel.content[index].nil?; line + second_panel.content[index]}
    Panel.new(width_percentage + second_panel.width_percentage,
              height_percentage,
              merged_content)
  end

  def place_on_top_of(second_panel)
    Panel.new(width_percentage,
              height_percentage + second_panel.height_percentage,
              content + second_panel.content
              )
  end
end
