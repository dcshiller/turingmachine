require_relative 'window_organization'
require 'colorize'

class Panel
  #include WinOrg
  attr_reader :cols, :rows, :panel_width, :panel_height, :content, :width_percentage, :height_percentage

  def initialize(width_percentage, height_percentage, content, background_color = :black)
    refresh_window_information
    @width_percentage = width_percentage
    @height_percentage = height_percentage
    @panel_width = @cols * width_percentage
    @panel_height = @rows * height_percentage
    @content = content
    @background_color = background_color
  end

  def make_content_fit
    (panel_height - content.count).to_i.times { content << [] }
    content.collect! {|line| puts line.flatten.count; line + [" "*(@panel_width - line.join("").length)] }
  end

  def draw_content
    content.each {|line| puts line.join("").colorize(background: @background_color)}
  end

  def place_side_by_side(second_panel)
    merged_content = content.collect.with_index {|line, index| line + second_panel.content[index]}
    Panel.new(width_percentage + second_panel.width_percentage,
              height_percentage+second_panel.height_percentage,
              merged_content)
  end
end
