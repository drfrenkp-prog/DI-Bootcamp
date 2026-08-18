# Master Reference: Precourse → Week 3 Day 1
Developers Institute – Data Analytics Bootcamp (Mattia Coletto)

*Note: Week 2 was skipped (away from the bootcamp Aug 10–17). This document jumps from Week 1 straight to Week 3, which is where OOP content actually begins.*

---

## How to use this document
Running index of everything covered so far — concepts, tools, and where the working code lives on GitHub (`https://github.com/drfrenkp-prog/DI-Bootcamp`, plus `DI-Bootcamp-Stage1` for early Git practice). Re-upload this file at the start of a new chat to instantly restore context without re-explaining the whole journey.

---

## PRECOURSE
*(unchanged from prior version — see below for full list)*

- **Python Fundamentals:** variables, data types, booleans/comparisons, strings, type conversion, operators (`+ - * / ** // % abs()`)
- **Control Flow:** `if/elif/else`, `for`/`while` loops, `range()`, `enumerate()`, `break`/`continue`/`pass`, `for...else`
- **Lists:** indexing, slicing, methods (`.append() .pop() .remove() .insert() .count() .sort() .reverse() .clear() .extend() .copy()`), `sorted()`, `sum()`, `zip()`, nested lists, list comprehension
- **Dictionaries:** `{}`, `.get()`, `.items()/.keys()/.values()`, `.update()`, `del`, nested dicts, dict comprehension
- **Tuples & Sets:** immutability, `.union()/.intersection()/.difference()`
- **Functions:** `def`, `return`, docstrings, positional/keyword args, defaults, `*args`/`**kwargs`, scope/`global`, closures, returning tuples, type hints
- **Errors:** `NameError KeyError AttributeError IndexError ValueError TypeError`, `try/except`, `raise`
- **Modules:** `import`, `random`, `math`, `collections` (`Counter, defaultdict, OrderedDict, namedtuple`), `if __name__ == '__main__':`
- **Advanced iteration:** `map()`, `filter()`, `functools.reduce()`, lambda functions
- **Git & GitHub:** full local→remote workflow, Personal Access Tokens, `git_tutorial_mattia` and `DI-Bootcamp-Stage1` practice repos
- **Excel/Google Sheets:** autofill/locale, grouping, conditional formatting, sorting/filtering, transpose, `DAYS()`, `VLOOKUP`, `DSUM/COUNTIF/SUMIF/SUMIFS`, cross-sheet refs, nested formulas, PivotTables/Calculated Fields, Consolidate, VBA `Call`, data cleaning (duplicates, imputation)

---

## WEEK 1 (Days 1–5)
*(unchanged from prior version)*

- **Day 1:** print/math/booleans/if-statements/user input; Daily Challenge: string length validation + progressive build
- **Day 2:** sets, tuples, list manipulation, float sequences, `enumerate`, `while True` validation, fruits/pizza/Cinemax exercises; Daily Challenge: multiples of a number + remove consecutive duplicates
- **Day 3:** dict comprehension via `zip()`, Cinemax #2, Zara nested-dict manipulation, Disney characters (`enumerate` + dict comp); Daily Challenge: Letter Index Dictionary + Affordable Items
- **Day 4:** function exercises (defaults, keyword args, list mutation, temperature logic); Daily Challenge: Coffee Shop Menu Manager (full CRUD, `while True` main loop); Daily Challenge 2: Matrix/Neo decoder (2D list, column iteration, `.isalpha()`)
- **Day 5:** Mini-projects **Tic Tac Toe** and **Hangman**; Daily Challenge: word sorting + longest word; extra challenge: Pair Sum Finder (set-based O(n) algorithm)

**Folders:** `Week1/Day1` through `Day5`, each with `ExercisesXP`/`DailyChallenge` subfolders. OOP practice (Person/Student, Animal/Dog/Cat) originally in `Week1/aaa`, renamed to **`Week1/OOP_Practice`**.

---

## WEEK 2 — Skipped (away Aug 10–17)

## WEEK 3

### Day 1 — Object-Oriented Programming (OOP) intro
**Folder:** `Week2/Day1/Untitled-2.py` (currently misfiled under Week2 — needs moving to `Week3/Day1` and organizing into `ExercisesXP` structure)

**New concepts introduced:**
- `class` — defining a custom blueprint/type
- `__init__(self, ...)` — constructor, runs automatically on object creation, sets up initial attributes
- `self` — refers to "this specific object"; determined by whatever is written before the dot when calling a method (e.g. `p.hello()` → `self = p`), not by creation order
- **Inheritance** — `class Student(Person):` — Student automatically gets everything Person has
- `super().__init__(...)` — calls the parent class's constructor to reuse its setup logic before adding subclass-specific attributes
- **Polymorphism** — subclass overrides a parent method (`hello()`) with its own version; same method name, different behavior per class

**Practice built:**
- `Animal` → `Dog`/`Cat` (sound() override example)
- `Person` → `Student` (name/last_name/age, plus Student adds `program`; both override `hello()`)
- Simple dog-behavior program (name input, `random.choice()` of actions, `while` loop with boolean flag) — built using **only Week 1 tools**, no OOP

**Still to cover (per original Week 2 roadmap):** OOP Inheritance/Encapsulation/Polymorphism/Multiple Inheritance (deeper dive), OOP + Modules, Python File I/O + JSON + API, Mini-Project Day

### Day 1 (parallel) — Claude Code & "Understanding Claude" course
- **Installed Claude Code** via PowerShell (`irm https://claude.ai/install.ps1 | iex`), added `C:\Users\Frenki\.local\bin` to PATH, logged in with Claude Pro subscription
- Used Claude Code scoped to `~/DI_Bootcamp` (trusted folder) to: summarize the repo, add a `hello_world()` function, run a Python file, check git status, write a commit message, commit, and push — all via natural-language requests instead of manual terminal commands
- Permission modes: Manual (asks every time) vs Auto; toggled with `Shift+Tab`
- **"Understanding Claude" course started** (separate from Python curriculum) — covers Claude ecosystem (Chat/Claude Code/Cowork), effective prompting, delegation, context windows/tokens, when to start a fresh conversation vs upload a document

---

## Concepts flagged as "not yet covered — coming later"
- File I/O, JSON, APIs
- OOP: Encapsulation, Multiple Inheritance (deeper), OOP + Modules
- pandas / data analysis libraries
- Virtual environments (`venv`) — introduced conceptually only

---

## Housekeeping notes
- `Week1/OOP_Practice/aaaa` — stray empty leftover file, flagged for cleanup, not yet removed
- Reference doc itself is committed to the repo as `Week1/Master_Reference_Precourse_to_Week1_2.md` — keep versioning it there so it survives across chat sessions

---

- File/folder currently named `Week2/Day1/...` should be moved to `Week3/Day1/...` to match the actual week — see repo steps below.

---

*Document generated as a study/navigation aid — not an official course artifact.*
