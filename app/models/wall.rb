class Wall
  HORIZONTAL = 12
  VERTICAL = 15

  @@state = { }

  def self.on?(x, y)
    !!@@state["#{x},#{y}"]
  end

  def self.toggle(x, y)
    @@state["#{x},#{y}"] = !@@state["#{x},#{y}"]
  end
end
