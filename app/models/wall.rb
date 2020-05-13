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
end
