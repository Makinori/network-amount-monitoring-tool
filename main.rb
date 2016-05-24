require 'bundler'
Bundler.require

### struct, core

DIFF_FILE = "/proc/net/dev"
LOG_FILE = "communication_log.txt"

MDate = Struct.new(:year, :month, :day)
Communicate = Struct.new(:interface, :receive, :transmit)
CommunicateLog = Struct.new(:date, :communicate_list)


def array_to_communicate (array)
  Communicate.new(array[0], array[1].to_i, array[2].to_i)
end

def array_to_date (array)
  MDate.new(array[0].to_i, array[1].to_i, array[2].to_i)
end

def arrays_to_communicatelog (arrays)
  CommunicateLog.new(array_to_date(arrays.first),
                     arrays.drop(1).map{|n| array_to_communicate n})
end


### file, parser 
ARR_ITEM = ["item"]

def parse_diff_str (str)
  str.split("\n").drop(2).map {|l| l.split(" ")}
    .map{|l| [l[0], l[1].to_i, l[9].to_i]}
end

def read_diff_file (file_path)
  parse_diff_str(File.open(file_path).read)
end


def parse_log_file (str)
  each_word = str.split("\n").map{|l| l.split(" ")}.delete_if {|l| l==[]}
    .insert(-1, ARR_ITEM).drop(1)
  
  this_array = []
  log_list = []
  
  each_word.each {|line|
    if line == ARR_ITEM and this_array!=[] then
      log_list.push(arrays_to_communicatelog this_array)
      this_array = []
    else
      this_array = this_array.push(line)
    end
  }
  
  log_list
end

def read_log_file (file_path)
  parse_log_file(File.open(file_path).read)
end

def log_list_to_str (log_list)
  log_list.map{|log|
    [ARR_ITEM]
      .concat([[log.date.year, log.date.month, log.date.day]])
      .concat(log.communicate_list.map{|c|
                [c.interface, c.receive, c.transmit]})     
  }.inject("") {|st,ll|
    st + ll.inject("") {|s, l| s+l.join(" ")+"\n"} + "\n"
  }
end

def write_log_file (file_path, communicate_logs)
  File.open(file_path, 'w') {|file| file.write(log_list_to_str communicate_logs)}
end


### T:todays_communicate, C:communicate_logs. f(T C) => X

def get_mdate ()
  p = Time.new()
  MDate.new(p.year, p.month, p.day)
end

def rinthesis_communicate (comus1, comus2)
  comus1.map{|c1|  
    c2 = comus2.find{|item| item.interface == c1.interface}
    if c2 != nil then
      comus2 = comus2.reject {|item| item == c2}
      Communicate.new(c1.interface,
                      c1.receive + c2.receive,
                      c1.receive + c2.receive)
    else
      c1
    end
  } + comus2
end

def subtract_communicate (comus2, comus1)
  comus1.map{|c1|  
    c2 = comus2.find{|item| item.interface == c1.interface}
    if c2 != nil then
      comus2 = comus2.reject {|item| item == c2}
      Communicate.new(c1.interface,
                      c1.receive - c2.receive,
                      c1.receive - c2.receive)
    else
      c1
    end
  } + comus2
end  

def rinthesis_log (mdate, commus1, commus2)
  CommunicateLog.new(mdate, rinthesis_communicate(commus1, commus2))
end

def todays_log_update (diff_commus, today_commus, date, ref_diff_com = [])

  updated_commu = rinthesis_communicate(today_commus,
                                        subtract_communicate(diff_commus, ref_diff_com))
    
  ref_diff_com  = rinthesis_communicate(diff_commus,
                                        ref_diff_com == [] ? [] : ref_diff_com)

  return CommunicateLog.new(date, updated_commu), ref_diff_com
end

def update_logs (diff_file_path, communicate_logs, date, ref_diff_com=[])
  
  if (today_commus = communicate_logs.find {|x| x.date == date}) == nil then
    today_commus = [] 
  else
    today_commus = today_commus.communicate_list
  end
  diff_commus = read_diff_file(diff_file_path).map {|x| array_to_communicate x}
  u_todays_log, u_ref_diff_com = # u:updated
    todays_log_update(diff_commus, today_commus, date, ref_diff_com)

  # u_c_l : updated communicate logs
  u_c_l = communicate_logs.select {|x| x.date != date} + [u_todays_log]

  return u_c_l, u_ref_diff_com
end

def change_day (diff_file_path, communicate_logs, date_ago,ref_diff_com=[])
  date_new = get_mdate()
  
  u_c_l, u_diff_com = update_logs(diff_file_path, communicate_logs, date_ago, ref_diff_com)

  u_c_l = u_c_l +  [CommunicateLog.new(date_new, [])]
  
  return u_c_l, u_diff_com, date_new
end



### Class application
class App
  
  attr_accessor :diff_file_path, :log_file_path, :communicate_logs, :now_communicate
  
  def initialize ()
    @diff_file_path = DIFF_FILE
    @log_file_path = LOG_FILE
    
    day = Time.new()
    @now = MDate.new(day.year, day.month, day.day)
    
    @communicate_logs = (read_log_file @log_file_path).sort {|a, b|
      a.date.year * 403 + a.date.month * 13 + a.date.day <=>
      b.date.year * 403 + b.date.month * 13 + b.date.day
    }
    
    @now_communicate =
      if ([] == (todays_log = @communicate_logs.select {|item| item.date == @now}))
        read_diff_file(DIFF_FILE)
      else
        #todays_log + read_diff_file( DIFF_FILE)
        # Gousei log file
      end
  end
  
end 


t = Time.new()
date = MDate.new(t.year, t.month, t.day)

app = App.new
#app.communicate_logs[0].communicate_list.map {|x| print x; print "\n"}
#print "\n\n"

#updated_log, reflected_commus,date = change_day(DIFF_FILE, read_log_file(LOG_FILE), date)

#updated_log.map{|x| print x; print "\n"}

#print "\n"
#print get_mdate()
