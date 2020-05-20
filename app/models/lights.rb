class Lights
  def self.set(state)
    new(state).set
  end

  def initialize(state)
    @state = state
  end

  def set
    shell_out
  end

  private

  def indexes_for(state)
    ([].tap do |values|
      state_array.each_with_index do |value, index|
        if value == state
          values.push(index)
        end
      end
    end).join(',')
  end

  def state_array
    @state_array ||= [].tap do |array|
      @state.each do |key, value|
        x,y = key.split(',').map(&:to_i)
        array[x_y_to_position(x, y)] = value
      end
    end
  end

  def shell_out
    `sudo ON="#{indexes_for('on')}" FINISH="#{indexes_for('finish')}" START="#{indexes_for('start')}" ./bin/set_lights`
  end

  def x_y_to_position(x, y)
    if x.odd?
      (Wall::VERTICAL * (Wall::HORIZONTAL - x - 1)) + (y)
    else
      (Wall::VERTICAL * (Wall::HORIZONTAL - x - 1)) + (Wall::VERTICAL - y - 1)
    end
  end
end
