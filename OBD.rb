
# require_relative "Data/Command"
# require_relative "Data/Connection"
# require_relative "Data/Response"

# port = '/dev/tty.usbserial-113010892918'

# obd = OBD::Connection.new(port = port)
# obd.connect
# obd[OBD.engine_rpm]

puts "03783E".to_i(16)


# puts obd[:pids_supported_1].raw_values
# puts obd[:pids_supported_2].raw_values
# puts obd[:pids_supported_3].raw_values
# puts obd[:pids_supported_4].raw_values
# puts obd[:pids_supported_5].raw_values
# puts obd[:pids_supported_6].raw_values
# puts obd[:pids_supported_7].raw_values

# puts "410B4B".split("\r").map { |x| x[4..-1] }
# puts obd[:calculated_engine_load]

