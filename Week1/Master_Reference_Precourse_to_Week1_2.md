# Master Reference: Precourse → Week 1
Developers Institute – Data Analytics Bootcamp (Mattia Coletto)

---

## How to use this document
This is a running index of everything covered so far — concepts, tools, and where the actual working code lives on GitHub (`https://github.com/drfrenkp-prog/DI-Bootcamp` and `https://github.com/drfrenkp-prog/DI-Bootcamp-Stage1` for early Git practice). Use it to quickly find "did I learn this yet?" and "where's the code for that?"

---

## PRECOURSE

### Python Fundamentals
- **Variables** — naming, assignment (`=`), dynamic typing, multiple assignment (`a, b = 1, 2`)
- **Data types** — `int`, `float`, `str`, `bool`, `list`, `dict`, `tuple`, `NoneType`; checked with `type()`
- **Booleans & comparisons** — `True`/`False`, `==`, `!=`, `<`, `>`, `and`, `or`; type-mismatch behavior (`==` never errors, `<`/`>` can `TypeError` across types)
- **Strings** — immutability, indexing, slicing (`[start:end:step]`), `len()`, `.upper()`, `.lower()`, concatenation, f-strings, `\n`
- **Type conversion** — `int()`, `float()`, `str()`
- **Operators** — `+ - * /`, `**` (exponent), `//` (floor division), `%` (modulo), `abs()`

### Control Flow
- `if` / `elif` / `else`, nested conditionals
- `for` loops, `while` loops, `range(start, stop, step)`, `enumerate()`
- `break`, `continue`, `pass`
- `for...else` / `while...else` (recognize, rarely used)

### Lists
- Creation, indexing (0-based), negative indexing, slicing
- Methods: `.append()`, `.pop()`, `.remove()`, `.insert()`, `.count()`, `.sort()`, `.reverse()`, `.clear()`, `.extend()`, `.copy()`
- `sorted()` vs `.sort()` (new list vs in-place)
- `sum()`, `zip()`
- Nested lists (2D lists / grids)
- List comprehension: `[expr for item in iterable if condition]`

### Dictionaries
- Key-value pairs, `{}`, accessing with `[]` and `.get()`
- `KeyError` vs `.get()` returning `None`
- `.items()`, `.keys()`, `.values()`, `.update()`, `del`
- Nested dictionaries, list of dictionaries
- Dictionary comprehension: `{key: value for ... }`

### Tuples & Sets
- Tuples: immutable, `()`, unpacking, `.count()`, `.index()`
- Sets: `{}`, no duplicates, unordered, `.add()`, `.remove()`, `.union()`, `.intersection()`, `.difference()`

### Functions
- `def`, parameters, `return`, docstrings
- Positional vs keyword arguments, default parameter values
- `*args` (tuple of positional args), `**kwargs` (dict of keyword args)
- Argument unpacking when calling: `func(*list)`, `func(**dict)`
- Local vs global scope, the `global` keyword
- Closures (inner functions accessing outer scope)
- Returning tuples and unpacking on the call line
- Type hints (optional): `def add(a: int, b: int) -> int:`

### Errors & Debugging
- `NameError`, `KeyError`, `AttributeError`, `IndexError`, `ValueError`, `TypeError`
- `try` / `except` (catch specific exceptions), `raise`
- `pdb` (mentioned, not used in depth)

### Modules
- `import`, `from...import`, `import...as`
- Built-in modules: `random` (`randint`, `random`, `choice`), `math`, `collections` (`Counter`, `defaultdict`, `OrderedDict`, `namedtuple`)
- `if __name__ == '__main__':` pattern

### Advanced Iteration (introduced, lighter use)
- `map()`, `filter()`, `functools.reduce()`
- Lambda functions: `lambda args: expression`

### Git & GitHub
- `git init`, `git branch -M main`, `git status`, `git add`, `git commit -m`, `git push origin main`
- `git remote add origin <url>`, `git remote -v`
- `git clone`, `git pull`
- Personal Access Tokens (classic) for authentication
- GitHub repo creation, README files, collaborators
- Practice repo: `git_tutorial_mattia` (hello.txt exercise)
- `DI-Bootcamp-Stage1` repo: README + HTML exercise folders

### Excel / Google Sheets
- Autofill, fill handle, locale settings (fixed month-autofill bug via Sheet locale)
- Grouping/outlining columns
- Inserting columns
- Conditional formatting vs manual formatting vs filtering
- Sorting (ascending/descending), filtering vs sorting vs deleting
- Hiding tabs (Excel: yes: Google Sheets: no direct equivalent)
- Transpose (Paste Special)
- `DAYS()` function, inclusive date ranges (+1 adjustment)
- `VLOOKUP` / `CERCA.VERT`, absolute references (`$`)
- `DSUM`, `COUNTIF`, `SUMIF` vs `SUMIFS` (single vs multi-condition)
- Cross-sheet references (`'Sheet'!$A$1`)
- Nested formulas (`INT(AVERAGE(...))`)
- PivotTables, Calculated Fields (vs editing source data directly)
- Consolidate (combining tables from separate ranges)
- VBA: combining macros via `Call` (vs copy-pasting code)
- Data cleaning concepts: duplicates, imputation (mean/median), irregularities vs errors

---

## WEEK 1

### Day 1 — Python Basics
**Folder:** `Week1/Day1/ExercisesXP`, `Week1/Day1/DailyChallenge`
- Exercises: print statements, math operators, boolean prediction quiz, variables, if statements, user input, odd/even checker, name comparison, height/roller-coaster checker
- Daily Challenge: string length validation (10 chars exactly), first/last character, progressive character-by-character build with `for` + slicing

### Day 2 — Sequences, Lists, Sets, Tuples, Loops
**Folder:** `Week1/Day2/ExercisesXP`, `Week1/Day2/DailyChallenge`
- Exercises: sets (favorite numbers, union), tuple immutability, list manipulation (basket), float sequence generation via loop, `for` loop with `enumerate` (index vs value), `while True` input validation, favorite fruits (`.split()`, `in`), pizza toppings (running list + cost), Cinemax tickets (age-based pricing)
- Daily Challenge (completed later): multiples of a number, remove consecutive duplicate letters

### Day 3 — Dictionaries
**Folder:** `Week1/Day3/ExercisesXP`, `Week1/Day3/DailyChallenge`
- Exercises: list-to-dict via `zip()`, Cinemax #2 (looping a dict with `.items()`), Zara brand dict (nested dict, `.pop()`/`.update()`/`del`, negative indexing), Disney characters (`enumerate()` + dict comprehension, 3 variations incl. sorted)
- Daily Challenge: Letter Index Dictionary (position tracking per letter), Affordable Items (data cleaning with `.replace()`, priority-ordered purchasing, `sorted()`)

### Day 4 — Functions
**Folder:** `Week1/Day4/ExercisesXP`, `Week1/Day4/DailyChallenge`, `Week1/Day4/DailyChallenge2`
- Exercises: display_message, favorite_book, describe_city (default params), random number guess, personalized shirts (default + keyword args), magicians (list mutation via functions), temperature advice (`main()` pattern, multi-branch conditionals)
- Daily Challenge: Coffee Shop Menu Manager — full CRUD program (`show_menu`, `add_item`, `update_price`, `delete_item`, `show_options`, `run_coffee_shop`) using a dictionary as the data store and a `while True` main loop
- Daily Challenge 2: Matrix/Neo decoder — 2D list transformation, column-wise iteration, `.isalpha()` filtering, symbol-to-space replacement logic

### Day 5 — Mini-Projects
**Folder:** `Week1/Day5/TicTacToe`, `Week1/Day5/Hangman`, `Week1/Day5/DailyChallenge`
- **Tic Tac Toe:** 2D board list, `display_board()`, `player_input()` with validation, `check_win()` (rows/cols/diagonals), `check_tie()`, `play()` main loop with `global`
- **Hangman:** `display_word()` (star-masking), `display_hangman()` (staged body parts), guess tracking with a list, win/loss detection
- Daily Challenge: comma-separated word sorting (`.split()`/`sorted()`/`.join()`), longest word finder
- Extra daily challenge: Pair Sum Finder — efficient single-pass algorithm using a `set` to find all number pairs summing to a target (20,000-item list)

---

## Concepts flagged as "not yet covered — coming later"
- File I/O (reading/writing files directly)
- JSON handling
- APIs
- OOP (classes, inheritance, encapsulation, polymorphism, multiple inheritance)
- pandas / data analysis libraries
- Virtual environments (`venv`) — introduced conceptually, not yet used hands-on

---

*Document generated as a study/navigation aid — not an official course artifact.*
