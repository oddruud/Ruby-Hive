require 'logger'

class Logger
  def set_name(class_object, object_name)
    progname =  LoggerCreator.create_class_object_name(class_object, object_name)
  end
  
end

class LoggerCreator
 
 @@level = Logger::INFO
 @@loggers = Array.new()
 
 def self.create_logger_with_name(logger_name, output = nil)
  output = output || STDOUT 
  logger= Logger.new(output) 
  logger.progname = logger_name 
  logger.level = @@level
  logger.formatter = proc { |severity, datetime, progname, msg|
    "[#{datetime.strftime("%H:%M:%S")}] #{severity}-#{progname}: #{msg}\n"
  }       
  @@loggers << logger
  return logger
 end
 

 def self.create_class_object_name(class_object, object_name)
  return "#{class_object.name}[#{object_name}]"
 end 
 
 def self.create_logger_for_class(class_object, output = nil) 
    raise "object must be a class" unless class_object.kind_of? Class 
    return self.create_logger_with_name(class_object.name)
 end
 
 def self.create_logger_for_class_object(class_object, object_name=nil, output = nil) 
    raise "object must be a class" unless class_object.kind_of? Class 
    return self.create_logger_with_name(create_class_object_name(class_object, object_name))
 end

 def self.set_level(level) 
   puts "loggerCreator level: #{level}"
   @@level = level
   @@loggers.each do |logger|
     logger.level = level
   end
 end
end