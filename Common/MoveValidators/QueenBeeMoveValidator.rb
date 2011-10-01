require 'MoveValidators/MoveValidator'  

class QueenBeeMoveValidator < MoveValidator
  def initialize
    
  end
  
  def self.validate(boardState, move)
    return true
  end
  
end