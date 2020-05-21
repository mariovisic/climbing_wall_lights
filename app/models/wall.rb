class Wall
  HORIZONTAL = 12
  VERTICAL = 15
  DEFAULT_STATE = 'off'

  STATES = ['off', 'on', 'start', 'finish']

  @@state = { }
  @@brightness = 50

  def self.brightness
    @@brightness
  end

  def self.brightness=(brightness)
    @@brightness = brightness
  end

  def self.current_state(x, y)
    @@state["#{x},#{y}"] || DEFAULT_STATE
  end

  def self.toggle(x, y)
    @@state["#{x},#{y}"] = STATES[STATES.find_index(self.current_state(x, y)) + 1]

    set_lights
  end

  def self.turn_all_off
    @@state = { }

    set_lights
  end

  def self.turn_all_on
    (0..HORIZONTAL - 1).each do |x|
      (0..VERTICAL - 1).each do |y|
        @@state["#{x},#{y}"] = 'on'
      end
    end

    set_lights
  end

  def self.set_lights
    Lights.set(@@state, @@brightness)
  end
end
