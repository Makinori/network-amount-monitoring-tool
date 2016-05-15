#encoding:UTF-8
require 'tk'
load 'main.rb'

class GUI

  @tree = "hoge"
  @CommunicateLogs = []
  
  def initialize (communicate_logs)
    @CommunicateLogs = communicate_logs
    set_tree()
 
  end

  def set_tree ()
    
    @tree = Ttk::Treeview.new(show: :headings).pack
    @tree['columns'] = 'Date Receive Transmit total'
    @tree['columns'].zip(%w(Date Recieve Transmit Total)).each {|col, name|
      @tree.heading_configure(col, text:name)
    }

    date = ""
    
    @CommunicateLogs.map{|log|
      date = log.date.year.to_s + "/"+log.date.month.to_s + "/" + log. date.day.to_s
      tran = log.communicate_list.map{|c| c.transmit}.reduce(&:+)
      reci = log.communicate_list.map{|c| c.receive}.reduce(&:+)
      @tree.insert(value:[date,
                          reci,
                          tran,
                          ""])
    }
  end
  
  def loop ()
    Tk.mainloop
  end

end



gui = GUI.new(read_log_file LOG_FILE)
#gui.set_tree_items(read_log_file LOG_FILE)
gui.loop()
