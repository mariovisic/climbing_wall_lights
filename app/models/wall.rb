class Wall
  HORIZONTAL = 12
  VERTICAL = 15
  DEFAULT_STATE = 'off'

  STATES = ['off', 'on', 'start', 'finish']

  @@state = { }

  def self.current_state(x, y)
    @@state["#{x},#{y}"] || DEFAULT_STATE
  end

  def self.toggle(x, y)
    @@state["#{x},#{y}"] = STATES[STATES.find_index(self.current_state(x, y)) + 1]
  end

  def self.turn_all_off
    @@state = { }
  end

  def self.turn_all_on
    (0..HORIZONTAL).each do |x|
      (0..VERTICAL).each do |y|
        @@state["#{x},#{y}"] = 'on'
      end
    end
  end

  def self.x_y_to_position(x, y)
    if x.even?
      (VERTICAL * x) + (y + 1)
    else
      (VERTICAL * x) + (VERTICAL - y)
    end
  end
end
