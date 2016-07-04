require 'colorize'

class PanelTile

  def initialize(text, background_color, width)
    @selected = false
    @width = width
    @text_color = :black
    @selected_color = :red
    @background_color = background_color
    @text = text
    @object = ""
  end

  def to_s
    text_string = @text
    text_string += " " until text_string.uncolorize.length >= @width
    color = (@selected ? @selected_color : @text_color)
    text_string.colorize(color: color, background: @background_color)
  end

  def toggle_selection
    @selected = !@selected
  end

end
