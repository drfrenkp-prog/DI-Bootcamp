user_string = input("Enter a string (exactly 10 characters): ")
if len(user_string) < 10:
    print("String not long enough.")
elif len(user_string) > 10:
    print("String too long.")
else:
    print("Perfect string")
    print(f"First character: {user_string[0]}")
    print(f"Last character: {user_string[-1]}")
    for i, char in enumerate(user_string):
        print(user_string[:i+1])
user_string = input("Enter a string (exactly 10 characters): ")
count = 0
for char in user_string:
    count += 1
if count < 10:
    print("String not long enough.")
elif count > 10:        
    print("String too long.")
else:
    print("Perfect string")
    print(f"First character: {user_string[0]}")
    print(f"Last character: {user_string[-1]}")
    for i, char in enumerate(user_string):
        print(user_string[:i+1])
        