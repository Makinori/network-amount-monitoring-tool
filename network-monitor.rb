
require 'clockwork'
include Clockwork

$:.unshift File.dirname(__FILE__)  
require "lib.rb"


app = App.new()

every(1.hour, 'normal_update', :at => ["*:05", "*:15", "*:25", "*:35", "*:45", "*:55"]) do
  app.normal_update
end

every(1.day, 'change_day_update', :at => ["0:10"]) do
  app.change_day_update
end



["SIGHUP","HUP","SIGINT","INT","SIGKILL","KILL","SIGTERM","TERM","EXIT"].map{|signal|
  Signal.trap(signal){|s|
    puts "exiting monitor network ammount"
    app.normal_update
  }
}



