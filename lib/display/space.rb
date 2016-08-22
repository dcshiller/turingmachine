class Space
  attr_reader :color, :mark

  def initialize(color = :red, mark = :"0")
    @color = color
    @mark = mark
  end

  def read_mark
    @mark
  end

  def to_string_array
    empty_space = " ".colorize(background: color)
    mark = "#{@mark}".black.colorize(background: color)
    [empty_space, mark, empty_space]
  end

  def to_s
    to_string_array.join("")
  end

  def write_mark(new_mark)
    @mark = new_mark
  end

end
