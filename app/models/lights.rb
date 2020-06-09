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

  TURN_ON_OFF_FADE_TIME = 2.0

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

  def turn_off
    if @lights.brightness > 0
      @lights.open

      state_array.each_with_index do |value, index|
        @lights[index] = STATES[value]
      end

      brightness = @lights.brightness
      delay = TURN_ON_OFF_FADE_TIME / @lights.brightness

      brightness.downto(0) do |step_brightness|
        @lights.brightness = step_brightness
        @lights.show
        sleep(delay)
      end

      @lights.close
    end
  end

  def turn_on
    if @lights.brightness > 0
      @lights.open

      state_array.each_with_index do |value, index|
        @lights[index] = STATES[value]
      end

      brightness = @lights.brightness
      delay = TURN_ON_OFF_FADE_TIME / @lights.brightness

      0.upto(brightness) do |step_brightness|
        @lights.brightness = step_brightness
        @lights.show
        sleep(delay)
      end

      @lights.close
    end
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
