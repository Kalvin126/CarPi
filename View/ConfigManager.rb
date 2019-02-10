require 'yaml'

class ConfigManager

  def initialize
    @config = YAML.load_file(File.join(File.dirname(__FILE__), 'config.yml'))
  end

  def port
    default = '/dev/ttyUSB0'

    obd_config = @config['obd']

    return default if obd_config.nil?

    port = obd_config['port']

    return default if port.nil?

    return port
  end

  def fetch_delay
    default = 500

    obd_config = @config['obd']

    return default if obd_config.nil?

    fetch_delay = obd_config['fetch_delay']

    return default if fetch_delay.nil?

    return fetch_delay
  end

end