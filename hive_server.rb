#!/usr/bin/env ruby

$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'Common' ) )
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'HiveServer' ) ) 

require "server" 
require 'optparse'
require 'LoggerCreator' 

LoggerCreator.setLevel(Logger::INFO)
logger = LoggerCreator.createLoggerWithName("server_main")

options = {}
 options[:port] = 3333
 options[:debug] = false

opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: HiveServer COMMAND [OPTIONS]"
  opt.separator  ""
  opt.separator  "Commands"
  opt.separator  "     start: start a hive server"
  opt.separator  "Options"

  opt.on("-p","--port", Integer ,"the portnumber") do |port|
    options[:port] = port || 3333
  end
  
   opt.on("-d","--debug", "debug") do |debug|
    options[:debug] = true
  end

  opt.on("-h","--help","help") do
    puts opt_parser
  end
  
end

opt_parser.parse!


case ARGV[0]
when "start"
  logger.info "starting hive game server on port #{options[:port]}"
  server= Server.new(options[:port], options[:debug])
 
  
end


