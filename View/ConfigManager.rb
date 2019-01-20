require 'yaml'

class ConfigManager

    def initialize
        @config = YAML.load_file(File.join(File.dirname(__FILE__), 'config.yml')) 
    end

    def port
        obd_config = @config['obd']

        return '/dev/ttyUSB0' if obd_config.nil? 
        
        port = obd_config['port']

        return '/dev/ttyUSB0' if port.nil? 

        return port
    end

end