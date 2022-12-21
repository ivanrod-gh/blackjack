require_relative 'card'

class Deck
  @all = []

  def initialize
    @deck = []
    @all << self
  end
end