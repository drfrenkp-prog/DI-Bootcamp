class Animal():
    def __init__(self, name):
        self.name = name
        self.actions = ("sleeping","eating")

    def sound(self):
        return ""

class Dog(Animal):
    def sound(self):
        return "bark"

class Cat(Animal):
    def sound(self):
        return "meow"\

animal_types = ['Dog', 'Cat']
animal_type =  input(f"Choose your animal: ({(' or ').join(animal_types)})")
animal_name = input()
          
             