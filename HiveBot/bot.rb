class Bot
  require 'communication'   
  require 'boardstate'
  attr_reader :com 
  attr_reader :boardState

  def initialize(host, port)
      @boardState = BoardState.new()
      @com = Communication.new(host, port)
  end

end
