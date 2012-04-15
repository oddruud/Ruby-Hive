class Hive::SaveGame 
  
attr_accessor :player1 
attr_accessor :player2  
attr_accessor :date  
attr_accessor :save_directory 
attr_accessor :file_name_prefix  
attr_accessor :move_history  

def initialize(game, save_directory, file_name_prefix)
  @save_directory = save_directory
  @file_name_prefix = file_name_prefix
  save(game)
end

def save(game)
  raise "game does not have two players" unless game.players == 2
  p1,p2 = game.player[0], game.player[1]
  @player1 = [p1.id , p1.color, p1.type]  
  @player2 = [p2.id , p2.color, p1.type] 
  @date = Time.now
  @move_history = game.moves.dup
  to_file
end 

def self.load_from_file( file_name )
  save = Hive::SaveGame.new( file_name ) 
  save.move_history = []
  f = File.open(file_name, 'r')
  f.each_line do |line|
    words = line.split
    case words[0]  
      when "DATE>" then
        save.date = words[1]
      when "PLAYER1>" then
        save.player1 = words[1].split(',')
      when "PLAYER2>" then
        save.player2 = words[1].split(',')
      when ">" then
        save.move_history << words[1].split(',')
      end  
  end 
  return save 
end

def file_path
  return "#{@file_name_prefix}_#{ @player1[0] }_VS_#{ @player2[0] }_#{@date}"
end

private

def to_file   
  f = File.open(file_path, 'w')
  f << to_s
  f.close
end

def to_s
  output << "DATE> #{@date}\n" 
  output << "PLAYER1> #{@player1}\n"
  output << "PLAYER2> #{@player2}\n"
  @move_history.each do |m|
    output << "> #{m}\n" 
  end
  return output
end  
  
end