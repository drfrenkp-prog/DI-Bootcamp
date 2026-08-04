keys = ['Ten', 'Twenty', 'Thirty']
values = [10, 20, 30]
combined_dict = {key: value for key, value in zip(keys, values)}
print(combined_dict)
family = {"rick": 43, 'beth': 13, 'morty': 5, 'summer': 8}
total_cost = 0
for name, age in family.items():
    if age < 3:
        print(f"{name}: Free ticket.")
    elif age <= 12:
        total_cost += 10
        print(f"{name}: $10 ticket.")
    else:
        total_cost += 15
        print(f"{name}: $15 ticket.")
print(f"Total cost: ${total_cost}")
brand = {
    "name": "Zara",
    "creation_date": 1975,
    "creator_name": "Amancio Ortega Gaona",
    "type_of_clothes": ["men", "women", "children", "home"],
    "international_competitors": ["Gap", "H&M", "Benetton"],
    "number_stores": 7000,
    "major_color": {
        "France": "blue",
        "Spain": "red",
        "US": ["pink", "green"]
    }
}        
brand["number_stores"] = 2
print(f"Zara sells clothes for {brand['type_of_clothes']}.")
brand["country_creation"] = "Spain"
if "international_competitors" in brand:
    brand["international_competitors"].append("Desigual")
del brand["creation_date"]
print(brand["international_competitors"][-1])
print(brand["major_color"]["US"])
print(len(brand))
print(brand.keys())
users = ["Mickey", "Minnie", "Donald", "Ariel", "Pluto"]
character_to_index = {name: index for index, name in enumerate(users)}
print(character_to_index)
index_to_character = {index: name for index, name in enumerate(users)}
sorted_users = sorted(users)
print(index_to_character)
sorted_character_to_index = {name: index for index, name in enumerate(sorted_users)}
print(sorted_character_to_index)