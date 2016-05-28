
require 'clockwork'
include Clockwork

load 'lib.rb'


app = App.new()

every(1.hour, 'normal_update', :at => ["*:05"]) do
  app.normal_update
end

every(1.day, 'change_day_update', :at => ["0:00"]) do
  app.change_day_update
end


at_exit {
  app.normal_update
}
