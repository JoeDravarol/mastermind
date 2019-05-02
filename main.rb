# Now refactor your code to allow the human player to choose whether he/she wants to be 
# the creator of the secret code or the guesser.

# Build it out so that the computer will guess if you decide to choose your own secret colors.
# Start by having the computer guess randomly (but keeping the ones that match exactly).

# Next, add a little bit more intelligence to the computer player so that, if the computer has 
# guessed the right color but the wrong position, its next guess will need to include that 
# color somewhere. Feel free to make the AI even smarter.

# Refactor to computer to be code-breaker
# 1. Ask whether the player like to be the code-maker or breaker
# 2. First have the computer randomly guess the code
# 3. After if the computer guess the digit but it's in the wrong position
# it should save that number and put it in a different position on its next turn

class String
  def red; "\e[31m#{self}\e[0m" end
  def green; "\e[32m#{self}\e[0m" end
end

class CodeMaker

  def generate_secret_code
    @secret_code = []
    i = 0
    while i < 4
      @secret_code[i] = 1 + rand(6)
      i += 1
    end
    @secret_code
  end

  def make_secret_code
    loop do
      puts "Enter your 4 digits secret code. It must be between 1 to 6"
      @secret_code = gets.chomp.split("").map(&:to_i)

      break if secret_code_valid?(@secret_code)
    end

    puts "Your secret code is #{@secret_code.join}."
  end

  def secret_code_valid?(code)
    code.length == 4 && code.all? { |digit| digit >= 1 && digit <= 6 }
  end
end

class CodeBreaker
  attr_accessor :guesses

  def get_guesses 
    loop do
      puts "Enter 4 numbers within the range of 1 to 6 to break the secret code!"
      guesses = gets.chomp
      # Turn value from string to integer
      @guesses = guesses.split("").map(&:to_i)
      
      break if guesses_valid?
    end
    @guesses
  end

  def guesses_valid?
    @guesses.length == 4 && @guesses.all? { |guess| guess >= 1 && guess <= 6 }
  end
end

class Game
  attr_accessor :code_breaker, :code_maker, :secret_code_copy, :guesses_copy, :turns

  def initialize
    @code_maker = CodeMaker.new
    @code_breaker = CodeBreaker.new
    display_instructions
    play_game
  end

  def display_instructions
    puts "***************************************"
    puts "*** Welcome To The Mastermind Game! ***"
    puts "***************************************"
    puts "======================================="
    puts "************ Instructions *************"
    puts "1. You have to break the secret code in"
    puts "   order to win the game"
    puts "2. You are given 5 guesses to break the"
    puts "   code. The code ranges between 1 to 6"
    puts "   A number can be repeated more than once!"
    puts "3. Each time you enter your guesses...."
    puts "   The computer will give you some hints"
    puts "   on whether your guess had correct digit,"
    puts "   incorrect digits or correct digits"
    puts "   that are in the incorrect position\n "
    puts "***************************************"
    puts "*********** GUIDES TO HINTS ***********"
    puts "***************************************"
    puts "======================================="
    puts "1. If you get a digit correct and it is"
    puts "   in the correct position, the digit "
    puts "   will be colored #{"green".green}"
    puts "2. If you get a digit correct but in the"
    puts "   wrong position, the digit will be colored white"
    puts "3. If you get the digit incorrect, the "
    puts "   digit will be colored #{"red".red}\n "
    puts "For example:"
    puts "If the secret code is:"
    puts "1523"
    puts "and your guess was:"
    puts "1562"
    puts "You will see the following result:"
    puts "#{"15".green}#{"6".red}2"
  end

  def display_remaining_turns
    puts "You have #{@turns} guesses remaining."
  end

  def out_of_turns?
    @turns -= 1
    out_of_turn = false
    
    if @turns == 0
      out_of_turn = true
      puts "The secret code was #{@secret_code_copy.join}. The code maker wins!" if !player_won?
    end

    out_of_turn
  end

  def give_hints
    hints = ""

    @secret_code_copy.each_index do |i|
      if @secret_code_copy[i] == @guesses_copy[i]
        hints << @guesses_copy[i].to_s.green

      elsif @secret_code_copy.include?(@guesses_copy[i])
        hints << @guesses_copy[i].to_s

      else
        hints << @guesses_copy[i].to_s.red
      end
    end

    puts "Hints:"
    puts hints
  end

  def play_game
    @turns = 5
    @secret_code_copy = @code_maker.generate_secret_code

    loop do
      display_remaining_turns
      @guesses_copy = @code_breaker.get_guesses
      give_hints

      break if game_ended?
    end

    play_again?
  end

  def player_won?
    player_won = false
    winning_code = []

    @secret_code_copy.each_index do |i|
      if @secret_code_copy[i] == @guesses_copy[i]
        winning_code << @guesses_copy[i]
      end
    end

    if winning_code.length == 4
      puts "The code breaker has cracked the secret code!"
      player_won = true
    end
    
    player_won
  end

  def game_ended?
    out_of_turns? || player_won?
  end

  def play_again?
    input = nil

    loop do
      puts "Would you like to Play again? Y/N?"
      input = gets.chomp.upcase

      break if input == "Y" || input == "N"
    end

    if input == "Y"
      play_game
    else
      puts "Thanks for playing!"
    end
  end
end

new_game = Game.new
