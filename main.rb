require_relative 'participant'

bank = Actor.new('Bank')
puts "#{bank.name} #{bank.hand} #{bank.money}"
dealer = Participant.new('Dealer')
puts "#{dealer.name} #{dealer.hand} #{dealer.money} #{dealer.pass_count}"
player = Participant.new('Player')
puts "#{player.name} #{player.hand} #{player.money} #{player.pass_count}"