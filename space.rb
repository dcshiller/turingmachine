class Space
  attr_reader :color, :mark

  def initialize(color = :red, mark = :"0")
    @color = color
    @mark = mark
  end

  def to_s
    " #{@mark} ".colorize(background: color)
  end

  def write_mark(new_mark)
    @mark = new_mark
  end

  def read_mark
    @mark
  end

end
