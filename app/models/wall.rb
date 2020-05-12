class Wall
  HORIZONTAL = 12
  VERTICAL = 15

  START_HOLD_ROW_END = 6
  FINISH_HOLD_ROW_START = 15

  @@state = { }

  def self.on?(x, y)
    !!@@state["#{x},#{y}"]
  end

  def self.toggle(x, y)
    @@state["#{x},#{y}"] = !@@state["#{x},#{y}"]
  end

  def self.button_css_for(x, y)
    if y <= START_HOLD_ROW_END
      output = 'btn-success' # green
    elsif y >= FINISH_HOLD_ROW_START
      output = 'btn-danger' #red
    else
      output = 'btn-primary' #blue
    end

    if !on?(x, y)
      output += ' btn-light' #off
    end

    output
  end
end
