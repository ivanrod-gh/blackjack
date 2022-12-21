class Actor
  @all = []

  def initialize(name, money = 0)
    @name = name
    @hand = Hand.new
    @money = money
    @all << self
  end
end