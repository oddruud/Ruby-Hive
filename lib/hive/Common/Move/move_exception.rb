class Hive::MoveException < RuntimeError
  attr :ok_to_retry
  attr :code
  attr :message
  
  
  def initialize(code, message, ok_to_retry)
    @ok_to_retry = ok_to_retry
    @code = code 
    @message= message
  end
  
  def to_string() 
    return "Move Exception #{@code}: #{@message}, retry: #{@ok_to_retry}"
  end 
  
  
end