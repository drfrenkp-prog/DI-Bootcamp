def display_message():
    print("I am Mattia")
display_message()    
def favorite_book(title):
    print(f"One of my favorite books is {title}")

favorite_book("Lord of the Rings")
def describe_city(city, country="Unknown"):
    print(f"{city} is in {country}.")
describe_city("Reykjavik", "Iceland")
describe_city("Paris")
import random
def guess_number(user_number):
    random_number = random.randint(1, 100)
    if user_number == random_number:
        print("Success!")
    else:
        print(f"Fail! Your number: {user_number}, Random number: {random_number}")
guess_number(50)

def make_shirt(size="large", text="I love Python"):
    print(f"The size of the shirt is {size} and the text is {text}.") 

make_shirt()
make_shirt("medium")
make_shirt("small", "Custom message")
make_shirt(size="small", text="Hello!")


magician_names = ['Harry Houdini', 'David Blaine', 'Criss Angel']
def show_magicians(names):
    for name in names:
        print(name)

def make_great(names):
    for i in range(len(names)):
                names[i] = names[i] + " the Great"
make_great(magician_names)
show_magicians(magician_names)

def get_random_temp():
    return random.randint(-10, 40)

def main():
    temp = get_random_temp()
    print(f"The temperature right now is {temp} degrees Celsius.")

    if temp < 0:
        print("Brrr, that's freezing! Wear some extra layers today.")
    elif temp < 16:
        print("Quite chilly! Don't forget your coat.")
    elif temp < 24:
        print("Nice weather.")
    elif temp < 32:
        print("A bit warm, stay hydrated.")
    else:
        print("It's really hot! Stay cool.")

main()
