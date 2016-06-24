class Space

  attr_reader :color, :mark

  def initialize(color = :red, mark = :"0")
    @color = color
    @mark = mark
  end

  def to_s
    space_string = []
    space_string << " ".colorize(background: color)
    space_string << "#{@mark}".colorize(background: color)
    space_string << " ".colorize(background: color)
    space_string
  end

  def write_mark(new_mark)
    @mark = new_mark
  end

  def read_mark
    @mark
  end

end
