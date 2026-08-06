import random

wordslist = ['correction', 'childish', 'beach', 'python', 'assertive', 'interference', 'complete', 'share', 'credit card', 'rush', 'south']
word = random.choice(wordslist)

def display_word(word, guessed_letters):
    display = ""
    for letter in word:
        if letter in guessed_letters:
            display += letter
        else:
            display += "*"
    return display

def display_hangman(wrong_guesses):
    stages = [
        "",
        "Head",
        "Head, Body",
        "Head, Body, Left Arm",
        "Head, Body, Left Arm, Right Arm",
        "Head, Body, Left Arm, Right Arm, Left Leg",
        "Head, Body, Left Arm, Right Arm, Left Leg, Right Leg"
    ]
    print(f"Body parts shown: {stages[wrong_guesses]}")

guessed_letters = []
wrong_guesses = 0
max_wrong_guesses = 6

while wrong_guesses < max_wrong_guesses:
    print(display_word(word, guessed_letters))
    display_hangman(wrong_guesses)
    guess = input("Guess a letter: ").lower()
    if guess in guessed_letters:
        print("You already guessed that letter. Try again.")
        continue
    guessed_letters.append(guess)
    if guess in word:
        print(f"Good guess! '{guess}' is in the word.")
    else:
        wrong_guesses += 1
        print(f"Sorry, '{guess}' is not in the word.")

    all_guessed = True
    for letter in word:
        if letter not in guessed_letters:
            all_guessed = False
    if all_guessed:
        print(f"Congratulations! You guessed the word: {word}")
        break

if wrong_guesses == max_wrong_guesses:
    print(f"Game over! The word was: {word}")                        