require_relative 'Actor'

class Participant < Actor
  @all = []

  def initialize(pass_count)
    super
    @pass_count = pass_count
    @all << self
  end
end