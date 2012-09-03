require 'chingu'
require 'logger'

class Hive::Interface < Chingu::GameObject

attr_accessor :on_next   
attr_accessor :on_previous
attr_accessor :on_play
attr_accessor :on_pause
attr_reader :logger

def initialize 
  self.input= {:released_right => :next, 
               :released_left => :previous, 
               :released_enter => :play, 
               :released_space => :pause}
               
  @logger = Logger.new_for_object( self )
  @logger.info "INTERFACE CREATED"
end

def next
  @logger.info "NEXT"
  puts "bla"
end

def previous
  @logger.info "PREVIOUS"
end

def play
  @logger.info "PLAY"
end

def pause
  @logger.info "PAUSE"
end

end
