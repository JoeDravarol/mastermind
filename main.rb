# Next, add a little bit more intelligence to the computer player so that, if the computer has 
# guessed the right color but the wrong position, its next guess will need to include that 
# color somewhere. Feel free to make the AI even smarter.

# Refactor code (AI more intelligent)
# 1. Create a simiar loop to the hints method which output white text
# 2. Save the number and also its index
# 3. On next guess put the number somewhere else beside it's index or the correct position digit

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
    @secret_code
  end

  def secret_code_valid?(code)
    code.length == 4 && code.all? { |digit| digit >= 1 && digit <= 6 }
  end
end

class CodeBreaker
  attr_accessor :guesses, :ai_guesses, :ai_correct_position

  def initialize
    @ai_correct_position = [0, 0, 0, 0]
  end

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

  def get_ai_guesses
    @ai_guesses = []
    i = 0 

    while i < 4
      if @ai_correct_position[i] == 0
        @ai_guesses[i] = 1 + rand(6)
      else
        @ai_guesses[i] = @ai_correct_position[i]
      end
      i += 1
    end

    @ai_guesses
  end

  def store_ai_correct_digit(secret_code)

    secret_code.each_index do |i|   
      if secret_code[i] == @ai_guesses[i]
        @ai_correct_position[i] = @ai_guesses[i]
      end
    end

  end

end

class Game
  attr_accessor :code_breaker, :code_maker, :secret_code_copy, :guesses_copy, :turns, :player_role

  def initialize
    @code_maker = CodeMaker.new
    @code_breaker = CodeBreaker.new
    display_welcome
    get_player_role
    display_instructions
    play_game
  end

  def display_welcome
    puts "***************************************"
    puts "*** Welcome To The Mastermind Game! ***"
    puts "***************************************"
    puts "======================================="
  end

  def get_player_role
    loop do
      puts "Which role would you like to play as?"
      puts "1. Code Maker || 2. Code Breaker"
      puts "Please select 1 or 2"
      @player_role = gets.chomp
      
      break if @player_role == "1" || @player_role == "2"
    end
  end

  def display_instructions
    puts "***************************************"
    puts "************ Instructions *************"
    puts "***************************************"
    puts "======================================="

    if @player_role == "1"
      code_maker_instructions
    else
      code_breaker_instructions
    end

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

  def code_breaker_instructions
    puts "1. You have to break the secret code in"
    puts "   order to win the game"
    puts "2. You are given 5 guesses to break the"
    puts "   code. The code ranges between 1 to 6"
    puts "   A number can be repeated more than once!"
  end

  def code_maker_instructions
    puts "1. You will create a 4 digits secret code."
    puts "   The code must be between 1 to 6."
    puts "2. The AI/Computer will have 5 guesses to"
    puts "   try and crack your secret code. You win"
    puts "   if your secret code is not cracked"
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

  def give_hints(guesses)
    hints = ""

    @secret_code_copy.each_index do |i|
      if @secret_code_copy[i] == guesses[i]
        hints << guesses[i].to_s.green

      elsif @secret_code_copy.include?(guesses[i])
        hints << guesses[i].to_s

      else
        hints << guesses[i].to_s.red
      end
    end

    puts "Hints:"
    puts hints
  end

  def play_game
    @turns = 5
    @secret_code_copy = @player_role == "1" ? @code_maker.make_secret_code : @code_maker.generate_secret_code

    loop do
      display_remaining_turns
      @guesses_copy = @player_role == "1" ? @code_breaker.get_ai_guesses : @code_breaker.get_guesses
      puts "Your guess:"
      puts @guesses_copy.join()
      give_hints(@guesses_copy)

      if @player_role == "1"
        @code_breaker.store_ai_correct_digit(@secret_code_copy)
      end

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
      puts "The code breaker has cracked the secret code! The code breaker wins!"
      player_won = true
    end
    
    player_won
  end

  def game_ended?
    out_of_turns? || player_won?
  end

  def play_again?
    # Reset Code Breaker data
    @code_breaker.ai_correct_position = [0, 0, 0, 0]
    input = nil

    loop do
      puts "Would you like to Play again? Y/N?"
      input = gets.chomp.upcase

      break if input == "Y" || input == "N"
    end

    if input == "Y"
      get_player_role
      play_game
    else
      puts "Thanks for playing!"
    end
  end
end

new_game = Game.new
