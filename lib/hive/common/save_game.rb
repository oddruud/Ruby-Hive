require 'ftools'

class Hive::SaveGame 
  
attr_accessor :player1 
attr_accessor :player2  
attr_accessor :date  
attr_accessor :file_name  
attr_accessor :move_history  

def initialize( file_name )
  @file_name = file_name
end

def save( game)
  raise "game does not have two players" unless game.players == 2
  p1,p2 = game.player[0], game.player[1]
  @player1 = [p1.id , p1.color, p1.type]  
  @player2 = [p2.id , p2.color, p1.type] 
  @date = Time.now
  @move_history = game.moves.dup
  to_file( @file_name ) unless @file_name.nil?
end 

def self.load_from_file( file_name )
  save = Hive::SaveGame.new( file_name ) 
  save.move_history = []
  f = File.open(file_name, 'r')
  f.each_line do |line|
    words = line.split
    case words[0]  
      when "DATE:" then
        save.date = words[1]
      when "PLAYER1:" then
        save.player1 = words[1].split(',')
      when "PLAYER2:" then
        save.player2 = words[1].split(',')
      when "MOVE:" then
        save.move_history << words[1].split(',')
      end  
  end 
  return save 
end

def to_file( file_name )
  f = File.open(file_name, 'w')
  f << @date 
  f << @player1
  f << @player2
  @move_history.each do |m|
    f << m 
  end
end
  
end