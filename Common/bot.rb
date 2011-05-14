class Bot
  require 'communication'   
  require 'boardstate'
  attr_reader :com 
  
  def initialize(host, port, name)
     super(name)
    
      @com = Communication.new(host, port)
  end

end
