class RouteGenerator
  STARTING_ROWS = 4..6
  HAND_SPLIT_RANGE = 2..4

  def initialize(difficulty)
    @difficulty = difficulty
    @state = { }
    @hands = { }
    @last_position = nil
  end

  def self.generate(difficulty)
    new(difficulty).generate
  end

  def generate
    set_start_holds

    until hands_are_near_the_top
      set_hand_hold
    end

    set_last_position

    @state
  end

  private

  def set_start_holds
    starting_row = STARTING_ROWS.to_a.sample
    first_x_start = (0..Wall::HORIZONTAL-1).to_a.sample
    second_x_start_options = ((0..Wall::HORIZONTAL-1).to_a - [first_x_start]).select do |x_position|
      HAND_SPLIT_RANGE.include?((x_position - first_x_start).abs)
    end

    second_x_position = second_x_start_options.sample

    @hands[:left] = set(Position.new(first_x_start, starting_row), 'start')
    @hands[:right] = set(Position.new(second_x_position, starting_row), 'start')
  end


  def set(position, state)
    @state[position.to_s] = state

    position
  end

  def hands_are_near_the_top
    @hands.values.any?(&:near_top?)
  end

  def positions_above(y)
    positions = []
    (y+1..Wall::VERTICAL-1).each do |y_position|
      (0..Wall::HORIZONTAL-1).each do |x_position|
        positions.push(Position.new(x_position, y_position))
      end
    end
    positions
  end

  def set_hand_hold
    if @hands[:left].lower_than?(@hands[:right])
      move_hand = :left
      other_hand = :right
    else
      move_hand = :right
      other_hand = :left
    end

    positions = positions_above(@hands[move_hand].y).select do |position|
      position.in_range?(@hands[other_hand])
    end

    @last_position  = @hands[move_hand] = set(positions.sample, 'on')
  end

  def set_last_position
    set(@last_position, 'finish')
  end

  class Position
    attr_reader :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def near_top?
      y >= Wall::VERTICAL - 2
    end

    def lower_than?(position)
      if y == position.y
        # If left and right hands are equal then randomly select which to move :)
        rand(2) == 0
      else
        y < position.y
      end
    end

    def in_range?(other_hand)
      distance_to_other_hand = ((((x - other_hand.x).abs ** 2) + ((y - other_hand.y).abs ** 2)) ** 0.5)

      self != other_hand && HAND_SPLIT_RANGE.include?(distance_to_other_hand)
    end

    def to_s
      "#{x},#{y}"
    end

    def ==(other)
      x == other.x && y == other.y
    end
  end
end
