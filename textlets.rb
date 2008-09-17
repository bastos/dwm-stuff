# Write here your textlets or put in another file, see Dwm::#Config
module Dwm
  module Textlets
    def self.hello_world
      "Hello world"
    end
    
    def self.default
      "#{time} -  #{battery}"
    end
    
    def self.time
      Time.now.strftime("%H:%M %d/%m %a")
    end  

    def self.battery
      `acpi -a`.squeeze(" ").split()[3..4].join(' ')
    end  
  end
end
