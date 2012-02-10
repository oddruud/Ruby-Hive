#!/usr/bin/env ruby

$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'hive' ) ) 
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'hive/Common' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'hive/HiveServer' ) ) 
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'hive/HiveBot' ) ) 

require 'logger'

class Object

def name
	return @name.nil? ? object_id : @name
end

end

class Logger
 @@level = Logger::INFO
 @@loggers = Array.new()

  def set_name(class_object, object_name)
    progname =  Logger.format_class_object_name(class_object, object_name)
  end
   
 def self.new_with_name(name, output = nil)
  output = output || STDOUT 
  logger= Logger.new(output) 
  logger.progname = name 
  logger.level = @@level
  logger.formatter = proc { |severity, datetime, progname, msg|
    "[#{datetime.strftime("%H:%M:%S")}] #{severity}-#{progname}: #{msg}\n"
  }       
  @@loggers << logger
  return logger
 end
  
 def self.new_for_class(class_object, output = nil) 
    raise "object must be a class" unless class_object.kind_of? Class 
    return self.new_with_name(class_object.name)
 end
 
 def self.new_for_object(object, output = nil) 
    return self.new_with_name( self.format_class_object_name(object.class, object.name) )
 end

 def self.set_level(level) 
   puts "loggerCreator level: #{level}"
   @@level = level
   @@loggers.each do |logger|
     logger.level = level
   end
 end
 
 private
 
  def self.format_class_object_name(class_object, object_name)
  	return "#{class_object.name}[#{object_name}]"
  end 
  
end


class Hive
end

require 'server'
require 'rubygems' # only necessary in Ruby 1.8
require 'gosu'
require 'gamehandler'
require 'GraphicsView/viewer.rb'
require 'boardstate.rb'
require 'player.rb'

#server = Hive::Server.new(3333, true)
#window = Hive::GameView.new(server.game_handler)
#view_thread = Thread.new {window.show}
#server.start_test() 
#view_thread.join 
