#words_input = input("Enter words separated by commas: ")
#words_list = words_input.split(",")
#sorted_words = sorted(words_list)
#result = ",".join(sorted_words)
#print(result)


#def longest_word(sentence):
    #words = sentence.split()
    #longest = ""
    #for word in words:
        #if len(word) > len(longest):
            #longest = word
    #return longest

#print(longest_word("Margaret's toy is a pretty doll."))
#print(longest_word("A thing of beauty is a joy forever."))
#print(longest_word("Forgetfulness is by all means powerless!"))


import random

list_of_numbers = [random.randint(0, 10000) for _ in range(20000)]
target_number = 3728

seen_numbers = set()
found_pairs = []

for number in list_of_numbers:
    complement = target_number - number
    if complement in seen_numbers:
        found_pairs.append((number, complement))
    seen_numbers.add(number)
print(f"Found {len(found_pairs)} pairs that sum to {target_number}:")
for pair in found_pairs[:5]:
    print(pair)
