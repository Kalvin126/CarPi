class GaugeViewModel

  def initialize(obd, gauge)
    @obd = obd
    @gauge = gauge
  end

  def title
    @gauge.get_name
  end

  def setValue(value)
    if not @label.nil?
      @label.setText value
    end
  end

  # Updating

  def update(response = nil)
    if not @title_label.nil?
      @title_label.setText(title)
      @title_label.repaint
    end

    if not @value_label.nil?
      text = "N/A"

      if not response.nil?
        text = @gauge.display_value(response)
      end

      @value_label.setText(text)
      @value_label.repaint
    end
  end

  # Label

  def set_title_label(label)
    @title_label = label

    update
  end

  def set_value_label(label)
    @value_label = label

    update
  end

end
