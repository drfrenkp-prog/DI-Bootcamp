MATRIX_STR = '''
7ir
Tsi
h%x
i ?
sM# 
$a 
#t%'''

matrix = MATRIX_STR.split('\n')
matrix = matrix[1:]

max_length = 0
for row in matrix:
    if len(row) > max_length:
        max_length = len(row)

decoded_message = ""
previous_was_symbol = False
for col in range(max_length):
    for row in matrix:
        if col < len(row):
            char = row[col]
            if char.isalpha():
                decoded_message += char
                previous_was_symbol = False
            else:
                if not previous_was_symbol and decoded_message != "":
                    decoded_message += " "
                previous_was_symbol = True

print(decoded_message)