require 'logger'

class Logger
  def setName(classObject, objectName)
    progname =  LoggerCreator.createClassObjectName(classObject, objectName)
  end
  
end

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
 

 def self.createClassObjectName(classObject, objectName)
  return "#{classObject.name}[#{objectName}]"
 end 
 
 def self.createLoggerForClass(classObject, output = nil) 
    raise "object must be a class" unless classObject.kind_of? Class 
    return self.createLoggerWithName(classObject.name)
 end
 
 def self.createLoggerForClassObject(classObject, objectName=nil, output = nil) 
    raise "object must be a class" unless classObject.kind_of? Class 
    return self.createLoggerWithName(createClassObjectName(classObject, objectName))
 end

 def self.setLevel(level) 
   puts "loggerCreator level: #{level}"
   @@level = level
   @@loggers.each do |logger|
     logger.level = level
   end
 end
end