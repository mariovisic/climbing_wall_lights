require 'forwardable'

class RouteGenerator
  STARTING_ROWS = 4..6
  HAND_SPLIT_RANGE = 1..4

  def initialize
    @state = { }
    @left_hand = Hand.new(:left)
    @right_hand = Hand.new(:right)
    @hands = [@left_hand, @right_hand]
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

  def move_hand
    @hands.min { |hand_a, hand_b| hand_a.y_position <=> hand_b.y_position }
  end

  def other_hand
    @hands.max { |hand_a, hand_b| hand_a.y_position <=> hand_b.y_position }
  end

  def set_start_holds
    starting_positions = available_positions(STARTING_ROWS.begin, STARTING_ROWS.end)

    set(@left_hand, starting_positions.sample, 'start')
    set(@right_hand, (starting_positions.select { |position| position.in_range?(@left_hand) }).sample, 'start')
  end

  def set(hand, position, state=nil)
    if state.nil?
      state = position.near_top? ? 'finish' : 'on'
    end
    @state[position.to_s] = state
    hand.position = position
  end

  def hands_are_near_the_top
    @hands.any?(&:near_top?)
  end

  def available_positions(y_start, y_end = Wall::VERTICAL-1)
    [].tap do |positions|
      (y_start..y_end).each do |y_position|
        (0..Wall::HORIZONTAL-1).each do |x_position|
          positions.push(Position.new(x_position, y_position))
        end
      end
    end
  end

  def set_hand_hold
    positions = available_positions(move_hand.y).select do |position|
      position != move_hand.position && position.in_range?(other_hand)
    end

    position = positions.sample
    set(move_hand, position)
  end

  class Hand
    extend Forwardable

    def_delegators :@position, :x, :y, :near_top?

    attr_reader :side, :position

    def initialize(side)
      @side = side
    end

    def position=(position)
      @position = position
      @y_rand = rand
    end

    # Allow crossed positions only 5% of the time
    def crossed?(position)
      if @side == :left
        (position.x < x) || rand < 0.05
      else
        position.x > x || rand < 0.05
      end
    end

    # If left and right hands are equal then randomly select which to move :)
    def y_position
      @position.y + @y_rand
    end
  end

  class Position
    attr_reader :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def in_range?(other_hand)
      distance_to_other_hand = ((((x - other_hand.x).abs ** 2) + ((y - other_hand.y).abs ** 2)) ** 0.5)

      self != other_hand.position && !other_hand.crossed?(self) && HAND_SPLIT_RANGE.include?(distance_to_other_hand)
    end

    def near_top?
      y >= Wall::VERTICAL - 2
    end

    def to_s
      "#{x},#{y}"
    end

    def ==(other)
      x == other.x && y == other.y
    end
  end
end
