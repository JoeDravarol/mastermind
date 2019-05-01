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








# 1. Display instructions
# 2. Start out having the player being the code-breaker
# 3. Have the computer randomly select 4 digits code
# 4. Ask the player to guess
# 5. Figure out how you would display the color for the code
# 6. Display how many turns left the player has
# 7. Display player won if they guessed the code before turns runs out
# 8. Else display code-maker won