#!/usr/bin/env ruby
$: << File.expand_path(File.dirname(__FILE__) + "/")
require 'rubygems'
require 'config'

Dwm::Config::TEXTLETS_FILES.each{|file| require file}

# A DWM App to write things on dwm bar! I just call, DWM Textlets!
# Go to Dwm::#Config and see what you can do.
module Dwm
  # Start Dwm and Dwm Status Bar Updates or just updates
  def self.start
    # Will exec DWM and status, status in a thread.
    if Dwm::Config::EXEC
      Dwm::Status::start
      sleep Dwm::Config::SLEEP_TIME
      dwm = IO.popen(Dwm::Config::DWM_EXECUTABLE, "a")
      while dwm
          begin
            dwm.puts Dwm::Status::get
          rescue
            puts "Exiting"
            dwm.close
            exit
          end
          sleep Dwm::Config::SLEEP_TIME
      end
    else
      # Will not exec DWM but will run status
      Dwm::Status::start_without_thread
    end
  end

  module Status

    @status = "Woot!"
    
    @status_queue = {}.merge(Dwm::Config::INITIAL_TEXTLETS)

    # Start status updates async
    def self.start
      Thread.new do
        process_queue
      end
    end
    
    # Start sync status update
    def self.start_without_thread 
      process_queue
    end
    
    # Set status 
    def self.set text
      @status = text
      `echo '#{text}'>~/.dwm-status` if Dwm::Config::WRITE_FILE
      sleep Dwm::Config::SLEEP_TIME
    end

    # Get status
    def self.get
      @status
    end
    
    # Add a textlet to queue
    # ==== Example:
    # With a #Proc:
    #    Dwm::Status.add_to_queue :test, { :loop=>10, :after=>:die, :block=> Proc.new{|c| "Luke im your father"} }
    # With a Addon or a built in method    
    #    Dwm::Status.add_to_queue :test, { :loop=>3, :after=>:continue }    
    # ==== Parameters:
    # * key - can be any symbol to represent your textlet and if you don't give a block
    # a method with this name will me called at Dwm::Textlets.
    # * value - a hash with:
    #  * loop - Number of repetitions.
    #  * after - :die textlet will be removed from queue, :continue textlet will not be remove.
    #  * block - Optional, if you whant run a #Proc.
    def self.add_to_queue key, value
      @status_queue[key] = value if not @status_queue.has_key? key
    end

    # Remove textlet
    def self.remove_from_queue key
      @status_queue.delete key
    end
      
    private
    
    # Process queue
    def self.process_queue
      if @status_queue.size == 0
        set time
      else
        @status_queue.each do |k,v|
          v[:loop].times do 
            if v.has_key? :block
              set v[:block].call(self)
            else
              set Dwm::Textlets.send(k)
            end
          end        
          remove_from_queue(k) if v[:after] == :die
        end      
      end
      process_queue
    end      
    
  end  
  
end

Dwm.start
exit
