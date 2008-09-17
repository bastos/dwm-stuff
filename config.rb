# Dwm Texlets Configurations!
module Dwm
  module Config
    # Texlets files
    TEXTLETS_FILES = ['textlets.rb']
    # Textlets queue  
    INITIAL_TEXTLETS = {
       :test => { :loop=>10, :after=>:die, :block=> Proc.new{|c| "Luke im your father"} },
       :time => { :loop=>3, :after=>:die},
       :hello_world=>{:loop=>1, :after=>:die},
       :default=>{ :loop=>3, :after=>:continue}    
    }    
    # Change interval
    SLEEP_TIME = 1
    # If you want write a file with the text
    WRITE_FILE = false
    # Exec DWM, if not you can just write a file and use like this:
    #    #!/bin/sh
    #    exec ~/code/dwm/dwm.rb &
    #    while true
    #    do
    #      cat ~/.dwm-status
    #      sleep 2
    #    done | exec ~/dwm/dwm    
    EXEC = true
    # Humm
    DWM_EXECUTABLE = ENV["HOME"] + "/code/dwm/dwm"
  end
end

