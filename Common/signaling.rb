 
# Another Signals + Slots Implementation for Ruby (c) Axel Plinge 2006

# in order to avoid eval(...) cascades, all signaling Objects
# have to 'include Signaling' in order to be able to 'emit'
module Signaling   
  # connect one of our signals to one someones slot i.e. method
  def connect(signal,recipient,slot,*args)
    @connections = Hash.new unless @connections
    @connections[signal] = [] unless @connections[signal]
    @connections[signal].push [recipient.method(slot),args]
  end
  
  # emit :signal name => call associated method with args or default value
  def emit(name,*args)
    return if !@connections
    connected_slots =@connections[name]
    return if !connected_slots
    connected_slots.each do |slot|
      slot[0].call(*(slot[1]+args)) # concatenate *args lists
    end
  end
end
  
# connect sender's signal to one recipient's slot i.e. method
# called by sender.emit signal,*emit_args
#
# if *args are given, recipient.slot(*args,*emit_args) will be invoked,
# otherwise the just the args from after the emit statement are used
# recipient.slot(*emit_args)
def connect(sender,signal,recipient,slot,*args)
  sender.connect(signal,recipient,slot,*args)
end

