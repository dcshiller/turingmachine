require_relative 'window_organization'

class FullScreenGets
  include WinOrg

  def initialize(request)
    @request = request
  end


end
