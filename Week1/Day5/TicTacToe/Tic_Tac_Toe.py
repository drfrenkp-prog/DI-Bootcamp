board = [[' ', ' ', ' '],
         [' ', ' ', ' '],
         [' ', ' ', ' ']]

def display_board(board):
    print("TIC TAC TOE")
    print("*" * 15)
    for i in range(len(board)):
        row = board[i]
        print(f" {row[0]} | {row[1]} | {row[2]} ")
        if i != len(board) - 1:
            print("---|---|---")
    print("*" * 15)

def player_input(player):
    while True:
        row = int(input("Enter row: "))
        col = int(input("Enter column: "))
        if row in [1, 2, 3] and col in [1, 2, 3]:
            row -= 1
            col -= 1
            if board[row][col] == ' ':
                return row, col
            else:
                print("That cell is already taken. Try again.")
        else:
            print("Invalid input. Row and column must be between 1 and 3.")

def check_win(board, player):
    for row in board:
        if row[0] == player and row[1] == player and row[2] == player:
            return True

    for col in range(3):
        if board[0][col] == player and board[1][col] == player and board[2][col] == player:
            return True

    if board[0][0] == player and board[1][1] == player and board[2][2] == player:
        return True
    if board[0][2] == player and board[1][1] == player and board[2][0] == player:
        return True

    return False

def check_tie(board):
    for row in board:
        for cell in row:
            if cell == ' ':
                return False
    return True

def play():
    global board
    board = [[' ', ' ', ' '],
             [' ', ' ', ' '],
             [' ', ' ', ' ']]

    current_player = 'X'
    game_over = False

    while not game_over:
        display_board(board)
        print(f"Player {current_player}'s turn...")
        row, col = player_input(current_player)
        board[row][col] = current_player

        if check_win(board, current_player):
            display_board(board)
            print(f"Player {current_player} wins!")
            game_over = True
        elif check_tie(board):
            display_board(board)
            print("It's a tie!")
            game_over = True
        else:
            if current_player == 'X':
                current_player = 'O'
            else:
                current_player = 'X'

play()    
        