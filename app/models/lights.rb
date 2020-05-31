class Lights
  GPIO_PIN = 18

  RED = Ws2812::Color.new(0, 0xff, 0)
  GREEN = Ws2812::Color.new(0xff, 0, 0)
  BLUE = Ws2812::Color.new(0, 0, 0xff)
  WHITE = Ws2812::Color.new(0xff, 0xff, 0xff)
  LIGHT_GREY = Ws2812::Color.new(128, 128, 128)
  DARK_GREY = Ws2812::Color.new(60, 60, 60)
  OFF = Ws2812::Color.new(0, 0, 0)

  STATES = {
    'off' => OFF,
    'on' => BLUE,
    'start' => GREEN,
    'finish' => RED
  }

  def self.set(state, brightness)
    new(state, brightness).set
  end

  def self.play_boot_sequence(brightness)
    new({}, brightness).play_boot_sequence
  end


  def initialize(state, brightness)
    @state = state
    @lights = Ws2812::Basic.new(Wall::HORIZONTAL * Wall::VERTICAL, GPIO_PIN, brightness)
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

  def play_boot_sequence
    @lights.open

    image = ChunkyPNG::Image.from_file('./assets/image.png')

    WALL::VERTICAL.times do |y|
      WALL::HORIZONTAL.times do |x|
        colour = image[x][y]
        @lights[x_y_to_position(x, y)] = Ws2812::Color.new(colour.g, colour.r, colour.b)
      end
    end

    @lights.show
    sleep 1
    @lights.close
  end
end
