require 'logger'

class LoggerCreator
 
 @@level = Logger::INFO
 @@loggers = Array.new()
 
 def self.createLoggerWithName(loggerName, output = nil)
  output = output || STDOUT 
  logger= Logger.new(output) 
  logger.progname = loggerName 
  logger.level = @@level
  logger.formatter = proc { |severity, datetime, progname, msg|
    "[#{datetime.strftime("%H:%M:%S")}] #{severity}-#{progname}: #{msg}\n"
  }     
  
  @@loggers << logger
  return logger
 end
 
 def self.createLoggerForClass(classObject, output = nil) 
    raise "object must be a class" unless classObject.kind_of? Class 
    return self.createLoggerWithName(classObject.name)
 end
 
 def self.createLoggerForClassObject(classObject, objectName=nil, output = nil) 
    raise "object must be a class" unless classObject.kind_of? Class 
    return self.createLoggerWithName("#{classObject.name}[#{objectName}]")
 end

 def self.setLevel(level) 
   puts "loggerCreator level: #{level}"
   @@level = level
   @@loggers.each do |logger|
     logger.level = level
   end
 end
=begin 
 def enableInfo(value) 
   
 end 
 
 def enableDebug(value) 
   
 end 
 
 def enableFatal(value) 
   
 end 
=end 
end