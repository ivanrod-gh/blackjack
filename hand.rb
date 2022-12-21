require_relative 'card'

class Hand
  @all = []

  class << self
    attr_reader :all

    protected

    attr_writer :all
  end

  def initialize
    @deck = []
    self.class.all << self
  end
end