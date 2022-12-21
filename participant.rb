require_relative 'actor'

class Participant < Actor
  @all = []

  class << self
    attr_reader :all

    protected

    attr_writer :all
  end

  attr_reader :pass_count

  def initialize(name, pass_count = 0)
    super(name)
    @pass_count = pass_count
    self.class.all << self
  end
end