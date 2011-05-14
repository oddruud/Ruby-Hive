class NaiveBot < Bot
      include DRbUndumped
  
  def initialize(host, port,name)
    super(host,port, "Naive Bot:#{name}") 
  end
  


      
  
  
end
