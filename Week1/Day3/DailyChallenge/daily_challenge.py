word = input("Enter a word: ")
letter_indices = {}
for index, letter in enumerate(word):
    if letter in letter_indices:
        letter_indices[letter].append(index)
    else:
        letter_indices[letter] = [index]    
print(letter_indices)
items_purchase = {"Water": "$1", "Bread": "$3", "TV": "$1,000", "Fertilizer": "$20"}
wallet = "$300"
wallet = int(wallet.replace("$", ""))
cleaned_prices = {} 
for item, price in items_purchase.items():
    cleaned_price = int(price.replace("$", "").replace(",", ""))
    cleaned_prices[item] = cleaned_price
print(cleaned_prices)
basket = []
for item, price in cleaned_prices.items():
    if price <= wallet:
        basket.append(item)
        wallet -= price
if not basket:
    print("Nothing")
else:
    print(sorted(basket)) 
                      