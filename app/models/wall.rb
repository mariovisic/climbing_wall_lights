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

  @@powered_on = false
  @@state = { }
  @@brightness = MAX_BRIGHTNESS / 2

  def self.brightness
    @@brightness
  end

  def self.brightness=(brightness)
    @@brightness = brightness

    Lights.new(@@state, @@brightness).set
  end

  def self.set(x, y, state)
    @@state["#{x},#{y}"] = state

    Lights.new(@@state, @@brightness).set
  end

  def self.get(x, y)
    @@state["#{x},#{y}"] || DEFAULT_STATE
  end

  def self.turn_random_red(number)
    available_lights = []

    (0..HORIZONTAL - 1).each do |x|
      (0..VERTICAL - 1).each do |y|
        if get(x, y) == 'off'
          available_lights.push([x, y])
        end
      end
    end

    available_lights.shuffle.first(number.to_i).each do |light|
      set(*light, 'on')
      sleep 1.5
      set(*light, 'finish')
    end
  end

  def self.powered_on
    @@powered_on
  end

  def self.toggle_power
    if @@powered_on
      Lights.new(@@state, @@brightness).turn_off
    else
      Lights.new(@@state, @@brightness).turn_on
    end

    @@powered_on = !@@powered_on
  end

  def self.turn_all_off
    @@state = { }

    Lights.new(@@state, @@brightness).set
  end

  def self.turn_all_on
    (0..HORIZONTAL - 1).each do |x|
      (0..VERTICAL - 1).each do |y|
        @@state["#{x},#{y}"] = 'on'
      end
    end

    Lights.new(@@state, @@brightness).set
  end

  def self.load(state)
    @@state = state

    Lights.new(@@state, @@brightness).set
  end

  def self.load_moonboard(data)
    { 'START' => 'start', 'MOVES' => 'on', 'TOP' => 'finish' }.each do |type, state|
      data[type].each do |coordinate|
        x = coordinate[0].ord - 64
        y = coordinate[1..2].to_i - 1

        if x.between?(0, HORIZONTAL) && y.between?(0, VERTICAL)
          @@state["#{x},#{y}"] = state
        end
      end
    end

    Lights.new(@@state, @@brightness).set
  end
end
