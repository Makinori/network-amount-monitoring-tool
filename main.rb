
require 'tk'


DIFF_FILE = "/proc/net/dev"
LOG_FILE = "communication_log.txt"


Date = Struct.new(:year, :month, :day)
Communicate = Struct.new(:interface, :receive, :transmit)
CommunicateLog = Struct.new(:date, :communicate_list)


def array_to_communicate (array)
  Communicate.new(array[0], array[1].to_i, array[2].to_i)
end

def array_to_date (array)
  Date.new(array[0].to_i, array[1].to_i, array[2].to_i)
end

def arrays_to_communicatelog (arrays)
  CommunicateLog.new(array_to_date(arrays.first),
                     arrays.drop(1).map{|n| array_to_communicate n})
end


def parse_diff_str (str)
  str.split("\n").drop(2).map {|l| l.split(" ")}
    .map{|l| [l[0], l[1].to_i, l[9].to_i]}
end

def read_diff_file (file_path)
  parse_diff_str(File.open(file_path).read)
end


ARR_ITEM = ["item"]
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
  



#read_diff_file(DIFF_FILE)
#read_log_file(LOG_FILE)
