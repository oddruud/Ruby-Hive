class Fixnum
  def is_hive_slot_id?
    return to_i < Hive::Slot::UNCONNECTED
  end
  
  def is_hive_piece_id?
    return Hive::Piece.valid_id?(to_i) 
  end
  
  def is_valid_hive_id? 
    return is_hive_slot_id? || is_hive_piece_id?
  end
end