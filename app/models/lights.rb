class Lights
  GPIO_PIN = 18

  RED = Ws2812::Color.new(0, 0xff, 0)
  GREEN = Ws2812::Color.new(0xff, 0, 0)
  BLUE = Ws2812::Color.new(0, 0, 0xff)
  OFF = Ws2812::Color.new(0, 0, 0)

  STATES = {
    'off' => OFF,
    'on' => BLUE,
    'start' => GREEN,
    'finish' => RED
  }

  def self.set(state)
    new(state).set
  end

  def initialize(state)
    @state = state
    @lights = Ws2812::Basic.new(Wall::HORIZONTAL * Wall::VERTICAL, GPIO_PIN)
  end

  def set
    @lights.open

    state_array.each_with_index do |value, index|
      @lights[index] = STATES[value]
    end

    @lights.show
    @lights.close
  end

  private

  def state_array
    Array.new(@lights.count, 'off').tap do |array|
      @state.each do |key, value|
        x,y = key.split(',').map(&:to_i)
        array[x_y_to_position(x, y)] = value
      end
    end
  end

  def x_y_to_position(x, y)
    if x.odd?
      (Wall::VERTICAL * (Wall::HORIZONTAL - x - 1)) + (y)
    else
      (Wall::VERTICAL * (Wall::HORIZONTAL - x - 1)) + (Wall::VERTICAL - y - 1)
    end
  end
end
