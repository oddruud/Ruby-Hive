$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'hive' ) ) 
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'hive/common' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'hive/server' ) ) 
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'hive/bot' ) ) 

require 'logger'


class Array
  def remove_duplicates
      each do |m|
        delete_if { |m_| m == m_ && m.object_id != m_.object_id}
      end  
  end
end

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
require 'game'
require 'graphics_view/game_view_simple.rb'
require 'graphics_view/game_view_steps.rb'
require 'boardstate.rb'
require 'player.rb'

