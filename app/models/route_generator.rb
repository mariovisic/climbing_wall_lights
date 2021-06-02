class RouteGenerator
  STARTING_ROWS = 4..6
  HAND_SPLIT_RANGE = 2..4

  def initialize
    @state = { }
    @hands = { }
  end

  def self.generate
    new.generate
  end

  def generate
    set_start_holds

    until hands_are_near_the_top
      set_hand_hold
    end

    @state
  end

  private

  def set_start_holds
    available_starting_positions = available_positions(STARTING_ROWS.begin, STARTING_ROWS.end)
    left_hand = available_starting_positions.sample
    right_hand = (available_starting_positions.select { |position| position.in_range?(left_hand) }).sample

    @hands[:left] = set(left_hand, 'start')
    @hands[:right] = set(right_hand, 'start')
  end

  def set(position, state)
    puts "Setting: #{position} to #{state}"
    @state[position.to_s] = state

    position
  end

  def hands_are_near_the_top
    @hands.values.any?(&:near_top?)
  end

  def available_positions(y_start, y_end = Wall::VERTICAL-1)
    positions = []
    (y_start..y_end).each do |y_position|
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

    positions = available_positions(@hands[move_hand].y + 1).select do |position|
      position.in_range?(@hands[other_hand])
    end

    position = positions.sample

    if position.near_top?
      @hands[move_hand] = set(position, 'finish')
    else
      @hands[move_hand] = set(position, 'on')
    end
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
