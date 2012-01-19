require 'Move/move'

class PossibleMove < Move
  include DRbUndumped
  
  attr_reader :priority #priority is a value between 0 and ##
      
  def initialize(piece, slot)
    super(piece, slot)
    @priority = 0
  end    
      
  def add_importance( value )
    @priority += value
  end
  
  def no_importance!
    @priority = 0 
  end  
    
end 
