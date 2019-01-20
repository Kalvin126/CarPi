require_relative "../obd/Command"
require_relative "../obd/Connection"
require_relative "../obd/Gauge"
require_relative "../obd/Response"

require_relative "Dashboard"
require_relative "GaugeViewModel"
require_relative "DurationViewModel"
require_relative "ConfigManager"

require 'pry'

require 'fox16'
include Fox

class CarPi < FXApp

  def initialize
    super

    @config_manager = ConfigManager.new
    @obd = OBD::Connection.new @config_manager.port
    @dashboard = Dashboard.new self

    puts 'Initializing UI'
    setup_models
    setup_view_models
    setup_dashboard

    unless ENV['DO_NOT_CONNECT'] == '1'
      puts 'Initializing OBD Connection'

      @obd.connect
      puts 'Starting event loop'

      start_guage_fetch
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
    @timeout = addTimeout(0.2, :repeat => true) do |sender, sel, data|
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

    # repaint
  end

end

carPi = CarPi.new
