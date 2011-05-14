class Player
  require 'boardstate'
  attr_reader :boardState
  attr_writer :name
  
  include DRbUndumped
  
  def initialize(name)
   @name = name
  end

end
