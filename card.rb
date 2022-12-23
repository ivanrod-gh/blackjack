# frozen_string_literal: true

require_relative 'all'

class Card
  singleton_class.include All

  @all = []

  attr_reader :name, :value

  BASIC_CARDS = {
    two_hearts: { name: '2<>', value: 2 },
    two_diamonds: { name: '2<3', value: 2 },
    two_spades: { name: '2^', value: 2 },
    two_clubs: { name: '2+', value: 2 },
    three_hearts: { name: '3<>', value: 3 },
    three_diamonds: { name: '3<3', value: 3 },
    three_spades: { name: '3^', value: 3 },
    three_clubs: { name: '3+', value: 3 },
    four_hearts: { name: '4<>', value: 4 },
    four_diamonds: { name: '4<3', value: 4 },
    four_spades: { name: '4^', value: 4 },
    four_clubs: { name: '4+', value: 4 },
    five_hearts: { name: '5<>', value: 5 },
    five_diamonds: { name: '5<3', value: 5 },
    five_spades: { name: '5^', value: 5 },
    five_clubs: { name: '5+', value: 5 },
    six_hearts: { name: '6<>', value: 6 },
    six_diamonds: { name: '6<3', value: 6 },
    six_spades: { name: '6^', value: 6 },
    six_clubs: { name: '6+', value: 6 },
    seven_hearts: { name: '7<>', value: 7 },
    seven_diamonds: { name: '7<3', value: 7 },
    seven_spades: { name: '7^', value: 7 },
    seven_clubs: { name: '7+', value: 7 },
    eight_hearts: { name: '8<>', value: 8 },
    eight_diamonds: { name: '8<3', value: 8 },
    eight_spades: { name: '8^', value: 8 },
    eight_clubs: { name: '8+', value: 8 },
    nine_hearts: { name: '9<>', value: 9 },
    nine_diamonds: { name: '9<3', value: 9 },
    nine_spades: { name: '9^', value: 9 },
    nine_clubs: { name: '9+', value: 9 },
    ten_hearts: { name: '10<>', value: 10 },
    ten_diamonds: { name: '10<3', value: 10 },
    ten_spades: { name: '10^', value: 10 },
    ten_clubs: { name: '10+', value: 10 },
    jack_hearts: { name: 'J<>', value: 10 },
    jack_diamonds: { name: 'J<3', value: 10 },
    jack_spades: { name: 'J^', value: 10 },
    jack_clubs: { name: 'J+', value: 10 },
    queen_hearts: { name: 'Q<>', value: 10 },
    queen_diamonds: { name: 'Q<3', value: 10 },
    queen_spades: { name: 'Q^', value: 10 },
    queen_clubs: { name: 'Q+', value: 10 },
    king_hearts: { name: 'K<>', value: 10 },
    king_diamonds: { name: 'K<3', value: 10 },
    king_spades: { name: 'K^', value: 10 },
    king_clubs: { name: 'K+', value: 10 },
    ace_hearts: { name: 'A<>', value: { first: 1, second: 11 } },
    ace_diamonds: { name: 'A<3', value: { first: 1, second: 11 } },
    ace_spades: { name: 'A^', value: { first: 1, second: 11 } },
    ace_clubs: { name: 'A+', value: { first: 1, second: 11 } }
  }.freeze

  def initialize(name, value)
    @name = name
    @value = value
    self.class.all << self
  end

  BASIC_CARDS.each do |_, value|
    Card.new(value[:name], value[:value])
  end
end
