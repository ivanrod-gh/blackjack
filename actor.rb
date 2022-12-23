require_relative 'all'

class Actor
  self.singleton_class.include All

  BET_SIZE = 10
  INITIAL_MONEY = 100

  @all = []

  attr_accessor :money
  attr_reader :name, :hand

  def initialize(name, money = 0)
    @name = name
    @hand = []
    @money = money
    self.class.all << self
  end

  def erase_hand
    erase_hand!
  end

  def get_all_cards
    get_all_cards!
  end

  def get_cards_from_bank(bank)
    get_cards_from_bank!(bank)
  end

  def take_bet
    @money += BET_SIZE
  end

  def give_prize(participant)
    raise "Prize calling for invalid target!" unless participant.class == Participant
    raise "There is no more money in Bank!" if @money == 0
    @money -= BET_SIZE
    participant.take_prize
  end

  protected

  def erase_hand!
    @hand = []
  end

  def get_all_cards!
    raise "Method called for non-bank actor!" unless self.name.include?('Bank')
    Card.all.each { |card| self.hand << card }
  end

  def get_cards_from_bank!(bank)
    card = bank.hand[0]
    self.hand << card
    bank.hand.delete(card)
  end
end