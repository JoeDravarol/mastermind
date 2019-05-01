# Build a Mastermind game from the command line where you have 12 turns to guess the secret 
# code, starting with you guessing the computer’s random code.

# Think about how you would set this problem up!

# Build the game assuming the computer randomly selects the secret colors and the human 
# player must guess them. Remember that you need to give the proper feedback on how 
# good the guess was each turn!

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

# 6. Display how many turns left the player has
# 7. Display player won if they guessed the code before turns runs out
# 8. Else display code-maker won

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
end

class CodeBreaker
  attr_accessor :guesses

  def get_guesses 
    loop do
      puts "Please enter 4 numbers within the range of 1 to 6 to break the secret code!"
      guesses = gets.chomp
      # Turn value from string to integer
      @guesses = guesses.split("").map(&:to_i)
      
      break if guesses_valid?
    end
  end

  def guesses_valid?
    valid = false

    if @guesses.length == 4 && @guesses.all? { |guess| guess >= 1 && guess <= 6 }
      valid = true
    end

    valid
  end
end

class Game
  attr_accessor :code_breaker, :code_maker, :secret_code_copy, :guesses_copy, :turns

  def initialize
    @code_maker = CodeMaker.new
    @code_breaker = CodeBreaker.new
    @turns = 5
    display_instructions
    @secret_code_copy = @code_maker.generate_secret_code
    @code_breaker.get_guesses
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
    end

    out_of_turn
  end

end

new_game = Game.new