class Wall
  HORIZONTAL = 12
  VERTICAL = 15
  DEFAULT_STATE = 'off'

  # NOTE: The lights can go up to 255 for max brightness but they consume a lot
  # of current doing this and so it puts strain on the power supply for little
  # visual difference compared to 50% Lowering the max brightness also helps
  # colour uniformity especially as the LED strings get longer, so we can avoid
  # having to re-inject power so often if we reduce the maximum to 160/255
  MAX_BRIGHTNESS = 160

  STATES = ['off', 'on', 'start', 'finish']

  @@state = { }
  @@brightness = MAX_BRIGHTNESS / 2

  def self.brightness
    @@brightness
  end

  def self.brightness=(brightness)
    @@brightness = brightness

    set_lights
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

  def self.load(route)
    @@state = JSON.load(route.wall_state)

    set_lights
  end

  def self.set_lights
    Lights.set(@@state, @@brightness)
  end

  def self.play_boot_sequence
    # TODO: Create a fun boot sequence :)
    set_lights
  end
end
