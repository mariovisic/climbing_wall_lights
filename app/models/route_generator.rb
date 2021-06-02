class RouteGenerator
  STARTING_ROWS = 4..6
  STARTING_HAND_SPLIT = 2..4

  def initialize(difficulty)
    @difficulty = difficulty
    @state = { }
  end

  def self.generate(difficulty)
    new(difficulty).generate
  end

  def generate
    set_start_holds

    @state
  end

  private

  def set_start_holds
    starting_row = STARTING_ROWS.to_a.sample
    first_x_start = (0..Wall::HORIZONTAL-1).to_a.sample
    second_x_start_options = ((0..Wall::HORIZONTAL-1).to_a - [first_x_start]).select do |x_position|
      STARTING_HAND_SPLIT.include?((x_position - first_x_start).abs)
    end

    second_x_position = second_x_start_options.sample

    @left_hand = set(first_x_start, starting_row, 'start')
    @right_hand = set(second_x_position, starting_row, 'start')
  end

  def set(x, y, state)
    @state["#{x},#{y}"] = state

    [x, y]
  end
end
