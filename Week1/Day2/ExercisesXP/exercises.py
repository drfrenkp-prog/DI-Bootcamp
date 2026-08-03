my_fav_numbers = {7, 21, 42}
my_fav_numbers.add(13)
my_fav_numbers.add(99)
my_fav_numbers.remove(99)
friend_fav_numbers = {5, 21, 8}
our_fav_numbers = my_fav_numbers.union(friend_fav_numbers)
print(our_fav_numbers)
my_tuple = (1, 2, 3)
# my_tuple.append(4)
basket = ["Banana", "Apples", "Oranges", "Blueberries"]
basket.remove("Banana")
basket.remove("Blueberries")
basket.append("Kiwi")
basket.insert(0, "Apples")
apple_count = basket.count("Apples")
basket.clear()
print(basket)
print(apple_count)
my_floats = []
for num in range(3, 11):
    my_floats.append(num / 2)
print(my_floats)
for i in range(1, 21):
    print(i)
for index, value in enumerate(range(1, 21)):
    if index % 2 == 0:
        print(value)  
while True:
    name = input("Enter your name: ")
    if name.isdigit() or len(name) < 3:
        print("Please enter a valid name (not digits, at least 3 letters).")
    else:
        print("Thank you!")
        break
fruits_input = input("Enter your favorite fruits, separated by spaces: ")        
favorite_fruits = fruits_input.split()
fruit_to_check = input("Enter the name of a fruit: ")
if fruit_to_check in favorite_fruits:
    print("You chose one of your favorite fruits! Enjoy!")
else:
    print("You chose a new fruit. I hope you enjoy it!")
toppings = []
while True:
    topping = input("Enter a pizza topping (or 'quit' to finish): ")
    if topping == "quit":
        break
    else:
        toppings.append(topping)
        print(f"Adding {topping} to your pizza.")
total_cost = 10 + len(toppings) * 2.50
print(f"Your toppings: {toppings}")
print(f"Total cost: ${total_cost}")
num_people = int(input("How many people are in your group? "))
total_cost = 0
for i in range(num_people):
     age = int(input("Enter the age of a family member: "))
     if age < 3:
         print("Free ticket.")
     elif age <= 12:
        total_cost += 10
        print("Ticket cost: $10")
     else:
        total_cost += 15
        print("Ticket cost: $15")

print(f"Total cost for the group: ${total_cost}")
