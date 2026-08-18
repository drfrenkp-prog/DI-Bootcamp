

class Person:
    def __init__(self, name, last_name, age):
        self.name = name
        self.last_name = last_name
        self.age = age

    def hello(self):
        print(f"Hello I'm {self.name}")

class Student(Person):
    def __init__(self, name, last_name, age, program):
        super().__init__(name, last_name, age)
        self.program = program    

    def hello(self):
        print(f"Hello I'm {self.name} and study at {self.program}")

p = Person("Mattia", "Col", 35)
p.hello()

s = Student("Leni", "Ziag", 20, "Data Analytics")
s.hello() 

