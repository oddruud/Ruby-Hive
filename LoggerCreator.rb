require 'logger'

class LoggerCreator
 
 def self.createLoggerWithName(loggerName, output = nil)
  output = output || STDOUT 
  logger= Logger.new(output) 
  logger.progname = loggerName 
  logger.formatter = proc { |severity, datetime, progname, msg|
    "[#{datetime.strftime("%H:%M:%S")}] #{severity}-#{progname}: #{msg}\n"
  }     
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
 
end