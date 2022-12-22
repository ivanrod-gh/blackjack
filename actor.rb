class Actor
  @all = []

  class << self
    attr_reader :all

    def erase_all_instances(key)
      erase_all_instances! if key == 'new_game'
    end

    protected

    attr_writer :all

    def erase_all_instances!
      instance_variable_set(:@all, [])
    end
  end

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