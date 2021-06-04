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

  def move_hand
    @hands[:left].lower_than?(@hands[:right]) ?  :left : :right
  end

  def other_hand
    @hands[:right].lower_than?(@hands[:left]) ?  :left : :right
  end

  def set_start_holds
    starting_positions = available_positions(STARTING_ROWS.begin, STARTING_ROWS.end)

    @hands[:left] = set(starting_positions.sample, 'start')
    @hands[:right] = set((starting_positions.select { |position| position.in_range?(@hands[:left]) }).sample, 'start')
  end

  def set(position, state=nil)
    if state.nil?
      state = position.near_top? ? 'finish' : 'on'
    end
    @state[position.to_s] = state

    position
  end

  def hands_are_near_the_top
    @hands.values.any?(&:near_top?)
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
    positions = available_positions(@hands[move_hand].y + 1).select do |position|
      position.in_range?(@hands[other_hand])
    end

    @hands[move_hand] = set(positions.sample)
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
      # If left and right hands are equal then randomly select which to move :)
      y < position.y || (y == position.y && rand(2) == 0)
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
