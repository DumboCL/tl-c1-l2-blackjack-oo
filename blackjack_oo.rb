# blackjack_oo.rb

# Tealeaf Course 1 -- Lesson 2 Assignment
# Feb 12, 2015

# - The poker game need two person to play. One is Dealer, the other is player. 
# - At first, each person got 2 cards. Then player's turn first.
# - Player has 2 choices: 1. hit 2. stay
# - "stay" means "that's all" and go to the result checking part
# - "hit" means add another card. Each time player choose "hit", should check
#   the amount of the cards' value. 
#   if cands' value > 21 then busted
#   if cards' value == 21 then win
#   if cards' valud < 21 then choose again
# - if stay
#   then calculate the result.
# - Then Dealer's turn. Dealer must draw a card if amount is < 17.
# - At the end, count the result. If Dealer busted, bust. Then count who is 
#   bigger.

class DataValidation
  def self.options_include?(options = ['Y', 'N'], choose)
    options.include?(choose.upcase)
  end

  def self.continue_next(choose)
    choose.upcase == 'Y'
  end
end

class Card
  attr_accessor :suit, :value

  def initialize(suit,value)
    @suit = suit
    @value = value    
  end

  def to_s
    "#{suit}#{value}"   
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    ['♠︎','♥︎','♣︎','♦︎'].each do |suit_value|
      ['A','2','3','4','5','6','7','8','9','10','J','Q','K'].each do |rank_value|
        @cards.push(Card.new(suit_value,rank_value))
      end
    end
  end

  def draw_one_card
    cards.sample    
  end
end

class Hand
  attr_accessor :cards

  def initialize
    @cards = []    
  end

  def score
    result = 0
    count_A = 0

    cards.each do |card|
      if card.value.to_i == 0
        if card.value == 'A'
          count_A = count_A + 1
        else
          result += 10
        end
      else
        result += card.value.to_i
      end
    end

    if count_A > 0
      begin
        case 
        when result <= 10
          result = result + 11
        when result >10
          result = result + 1  
        end
        count_A -= 1
      end while count_A > 0
    end
    result
  end
end

class Board
  def self.draw(player, dealer, display_dealer_cards = false)
    system 'clear'
    puts "#{player.name}, Welcome to Blackjack Game."
    puts "==============="
    puts "Dealer's cards:"
    if display_dealer_cards
      dealer.hand.cards.each do |card|
        print card
        print "  "
      end
      puts
    else
      puts dealer.hand.cards.count
    end
    puts "==============="
    puts "Player's cards:"
    player.hand.cards.each do |card|
      print card
      print "  "
    end
    puts
    puts "===============" 
  end
end

class Player
  attr_accessor :name, :hand

  def initialize(name)
    @name = name
    @hand = Hand.new    
  end
end

class Game
  attr_accessor :player, :computer, :board, :deck

  def initialize(player_name)
    @player = Player.new(player_name)
    @computer = Player.new('computer')
    @board = Board.new
    @deck = Deck.new    
  end

  def continue_draw_card?(points)
    points >= 21 ? false : true
  end

  def show_result
    player_score = player.hand.score
    dealer_score = computer.hand.score
    Board.draw(player, computer, display_dealer_cards = true)
    if player_score > 21
      puts "Sorry, you scores #{player_score}, busted."
      puts "Dealer win!"  
    elsif player_score == 21
      puts "Aha, blackjack, you win!!"
    elsif dealer_score > 21
      puts "Oh, dealer scores #{dealer_score}, busted."
      puts "You win!"
    elsif dealer_score == 21
      puts "Aha, blackjack, dealer win!!"
    elsif player_score >= dealer_score
      puts "Player scores #{player_score}, dealer scores #{dealer_score}, You win!"
    else
      puts "Dealer scores #{dealer_score}, player scores #{player_score}, Dealer wins!"     
    end
    puts
  end

  def play
    player.hand.cards << deck.draw_one_card
    player.hand.cards << deck.draw_one_card
    computer.hand.cards << deck.draw_one_card
    computer.hand.cards << deck.draw_one_card
    Board.draw(player, computer)
    continue_draw_card = true
    # Player's turn
    begin
      puts "Please choose: 1) hit  2) stay"
      decision = gets.chomp.to_i
      if ![1, 2].include?(decision)
        puts "Error: you must enter 1 or 2"
        continue_draw_card = true
        decision = 1
        next 
      end
      if decision == 1
        player.hand.cards << deck.draw_one_card
        Board.draw(player, computer)
      end
      continue_draw_card = continue_draw_card?(player.hand.score)
    end while continue_draw_card && decision == 1

    # Dealer's turn
    if decision == 2
      begin
        computer.hand.cards << deck.draw_one_card
        Board.draw(player, computer)
      end while computer.hand.score < 17
      continue_draw_card = continue_draw_card?(computer.hand.score)
    end

    show_result   
  end
end

system 'clear'
puts "Please input your name:"
player_name = gets.chomp
begin
  game = Game.new(player_name)
  game.play
  begin 
    puts "Play again? (Y/N)"
    continue = gets.chomp
  end while !DataValidation.options_include?(choose = continue)
end while DataValidation.continue_next(continue)
