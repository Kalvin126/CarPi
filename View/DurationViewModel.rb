class DurationViewModel

  def initialize
  end

  def title
    return "Fetch duration"
  end

  # Updating

  def update(duration = nil)
    if not @value_label.nil?
      text = "N/A"

      if not duration.nil?
        display_val = duration.truncate(2)
        text = "#{display_val}"
      end

      @value_label.setText(text)
      @value_label.repaint
    end
  end
  
  # Label

  def set_title_label(label)
    @title_label = label

    @title_label.setText(title)
    @title_label.repaint
  end

  def set_value_label(label)
    @value_label = label

    update
  end

end
