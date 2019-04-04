require 'fox16'
include Fox

MARGIN = 6.0
SPACING = 200.0

class Dashboard < FXMainWindow

    def initialize(app)
      super(app, 'CarPi', :width => 480, :height => (800-40))
  
      @font = FXFont.new(app, 'Helvetica Neue', 22)
      @back_color = Fox.FXRGB(0, 0, 0)
  
      setBackColor(@back_color)
  
      layout_subviews self
    end
  
    def create
      super
  
      show(PLACEMENT_DEFAULT) #PLACEMENT_MAXIMIZED
    end
  
    def layout_subviews(frame)
      @mainframe = FXHorizontalFrame.new(frame, :opts => LAYOUT_FILL, :padLeft => MARGIN, :padRight => MARGIN, :padTop => MARGIN, :padBottom => MARGIN, :vSpacing => SPACING)
      @mainframe.setBackColor(@back_color)
  
      @left_frame = FXVerticalFrame.new(@mainframe, :opts => LAYOUT_FILL_X)
      @left_frame.setBackColor(@back_color)
  
      @right_frame = FXVerticalFrame.new(@mainframe, :opts => LAYOUT_FILL_X)
      @right_frame.setBackColor(@back_color)
    end
  
    ### Actions
  
    def add_control_label(gauge_viewmodel)
      gauge_viewmodel.set_title_label label(@left_frame, gauge_viewmodel.title, JUSTIFY_LEFT)
      gauge_viewmodel.set_value_label label(@right_frame, nil, JUSTIFY_RIGHT)
    end
  
    ### View Factory
  
    def label(parent, text, position)
      new_label = FXLabel.new(parent, text, :opts => LAYOUT_FILL_X, :padBottom => MARGIN)
  
      new_label.setBackColor(@back_color)
      new_label.setTextColor(Fox.FXRGB(255, 255, 255))
  
      new_label.setFont(@font)
      new_label.setJustify(position)
  
      return new_label
    end
  
  end
