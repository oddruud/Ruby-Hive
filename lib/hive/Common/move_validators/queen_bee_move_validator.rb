require 'move_validators/move_validator'  

class Hive::QueenBeeMoveValidator < Hive::MoveValidator
  def initialize
    
  end
  
  def self.validate(board_state,player, move)
    return true
  end
  
end