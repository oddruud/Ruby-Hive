#!/usr/bin/env ruby
require 'optparse'
require 'Server'

options = {}

opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: HiveCLI COMMAND [OPTIONS]"
  opt.separator  ""
  opt.separator  "Commands"
  opt.separator  "     login: login to ruby.com"
  opt.separator  "     help: help for anything"
  opt.separator  "     submit: upload your AI"
  opt.separator  "     play: play against an AI player"
  opt.separator  "     test: test the validity of your AI"
  opt.separator  ""
  opt.separator  "Options"

  opt.on("-l","--local URL","what is the local URL of your AI") do |local|
    options[:url] = local
  end

  opt.on("-u","--username","username") do |username|
    options[:username] = username
  end

  opt.on("-p","--password","password") do |password|
    options[:password] = password
  end

  opt.on("-h","--help","help") do
    puts opt_parser
  end
end

opt_parser.parse!

server = Server.new() 

case ARGV[0]
when "login"
  server.login(options[:username], options[:password])
when "play"
  puts "call stop on options #{options.inspect}"
when "submit"
  puts "call restart on options #{options.inspect}"
else
  puts opt_parser
end
