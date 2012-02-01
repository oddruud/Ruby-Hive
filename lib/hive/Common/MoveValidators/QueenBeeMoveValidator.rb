require 'MoveValidators/MoveValidator'  

class Hive::QueenBeeMoveValidator < Hive::MoveValidator
  def initialize
    
  end
  
  def self.validate(boardState,player, move)
    return true
  end
  
end