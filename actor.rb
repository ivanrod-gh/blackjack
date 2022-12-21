require_relative 'hand'

class Actor
  @all = []

  class << self
    attr_reader :all

    protected

    attr_writer :all
  end

  attr_reader :name, :hand, :money

  def initialize(name, money = 0)
    @name = name
    @hand = Hand.new
    @money = money
    self.class.all << self
  end
end