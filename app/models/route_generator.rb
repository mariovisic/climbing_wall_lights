class RouteGenerator
  def initialize(difficulty)
    @difficulty = difficulty
    @state = { }
  end

  def self.generate(difficulty)
    new(difficulty).generate
  end

  # FIXME: randomly generate holds instead of using fixed positions
  def generate
    @state["5,6"] = 'start'
    @state["3,6"] = 'start'

    @state
  end
end
