class System

    def initialize
      @brightness = 100

      system 'gpio -g mode 19 pwm'
    end

    ## Brightness

    def increase_brightness
      return if @brightness >= 100

      @brightness += 5

      set_brightness(@brightness)
    end

    def decrease_brightness
      return if @brightness <= 25

      @brightness -= 5

      set_brightness(@brightness)
    end

    def set_brightness(intensity)
      puts "Setting brightness to #{intensity}"

      system "gpio -g pwm 19 #{intensity}"
    end

end