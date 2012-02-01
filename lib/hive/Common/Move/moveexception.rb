class Hive::MoveException < RuntimeError
  attr :okToRetry
  attr :code
  attr :message
  
  
  def initialize(code, message, okToRetry)
    @okToRetry = okToRetry
    @code = code 
    @message= message
  end
  
  def toString() 
    return "Move Exception #{@code}: #{@message}, retry: #{@okToRetry}"
  end 
  
  
end