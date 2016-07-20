class Array
  def black
    self.collect! {|member| member.black}
  end

  def red
    self.collect! {|member| member.red}
  end
end
