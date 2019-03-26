require_relative "../obd/Command"
require_relative "../obd/Connection"
require_relative "../obd/Gauge"
require_relative "../obd/Response"
require_relative "../obd/Mock/MockConnection"

require_relative "Dashboard"
require_relative "GaugeViewModel"
require_relative "DurationViewModel"
require_relative "ConfigManager"

require 'fox16'
include Fox

class CarPi < FXApp

  def initialize
    super

    @config_manager = ConfigManager.new

    if ENV['MOCK'] == '1'
      @obd = MockConnection.new
    else
      @obd = OBD::Connection.new @config_manager.port
    end

    @dashboard = Dashboard.new self

    puts 'Initializing UI'
    setup_models
    setup_view_models
    setup_dashboard

    unless ENV['DO_NOT_CONNECT'] == '1'
      puts 'Initializing Connection'

      @obd.connect
      puts 'Starting event loop'

      start_guage_fetch
    end

    if ENV['RECORD_MOCK'] == '1'
      @frame = 0
    end

    create
    run
  end

  ## Setup

  def setup_models
    @gauges = [
      Gauge.turbo_boost,
      Gauge.fuel_air_ratio,
      Gauge.gauge_for_command(:intake_manifold_absolute_pressure),
      Gauge.gauge_for_command(:absolute_barometric_pressure),
      Gauge.gauge_for_command(:calculated_engine_load),
      Gauge.gauge_for_command(:fuel_system_status),
      Gauge.gauge_for_command(:engine_coolant_temperature_6),
      Gauge.gauge_for_command(:throttle_position),
      Gauge.gauge_for_command(:short_term_fuel_trim_bank_1),
      Gauge.gauge_for_command(:long_term_fuel_trim_bank_1)
    ]

    @commands = @gauges.flat_map { |gauge| gauge.get_commands }
  end

  def setup_view_models
    @view_models = @gauges.map { |gauge| GaugeViewModel.new @obd, gauge }
    @duration_view_model = DurationViewModel.new
  end

  def setup_dashboard
    @view_models.each { |control|
      @dashboard.add_control_label(control)
    }

    @dashboard.add_control_label(@duration_view_model)
  end

  ## Actions

  def start_guage_fetch
    delay = @config_manager.fetch_delay

    @timeout = addTimeout(delay, :repeat => true) do |sender, sel, data|
      update_data
    end 
  end

  def update_data
    start_time = Time.new

    results = update_guages

    total_time = Time.new - start_time
    puts "Fetching data took #{total_time} seconds"

    update_view(results)
    @duration_view_model.update(total_time)

    if ENV['MOCK'] == '1'
      @obd.increment_frame_data
    end

    if ENV['RECORD_MOCK'] == '1'
      dump_frame_data(results.values)

      @frame += 1
    end
  end

  def dump_frame_data(data)
    file_name = "frame_#{@frame}.json"
    data_folder = './obd/Mock/Data'

    json_data = data
      .map { |response|
        [response.command.command, response.raw_response]
      }
      .to_h

    File.open(data_folder + '/' + file_name, 'w') do |file|
      file.write JSON.pretty_generate(json_data)
    end
  end

  def update_guages
    puts "\nUpdating all commands"

    results = Hash.new

    @commands.each { |command_sym|
      command = OBD.method(command_sym).call

      puts "Fetching #{command.name}"

      results[command_sym] = @obd[command]
    }

    return results
  end

  def update_view(results)
    puts "\nUpdating View"

    @view_models.each { |view_model| view_model.update results }
  end

end

carPi = CarPi.new
