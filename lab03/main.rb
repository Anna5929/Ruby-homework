def get_block_size(board)
  board.size == 4 ? 2 : 3
end

def display_board(board, initial_board)
  size = board.size

  block_size = get_block_size(board)

  print "   "
  (1..size).each do |col|
    print "#{col} "
    print "  " if col % block_size == 0 && col < size
  end
  puts

  separator = "  +" + ("-" * (block_size * 2 + 1) + "+") * block_size
  puts separator

  board.each_with_index do |row, row_index|
    print "#{row_index + 1} | "

    row.each_with_index do |number, col_index|
      if number == 0
        cell = "·"
      elsif initial_board[row_index][col_index] == 0
        cell = "\e[96m#{number}\e[0m"
      else
        cell = number
      end

      print "#{cell} "
      print "| " if (col_index + 1) % block_size == 0 && col_index < size - 1

    end

    puts "|"
    puts separator if (row_index + 1) % block_size == 0

  end
end


def read_number(message, max_number, allow_zero = false)
  loop do
    print message
    input = gets.chomp

    if allow_zero && input == "0"
      return 0
    end

    if input.match?(/\A\d+\z/) && input.to_i.between?(1, max_number)
      return input.to_i
    end

    puts "Помилка! Введіть число від 1 до #{max_number}."
  end
end


def get_move(size)
  print "Введіть 'u' для скасування, 'h' для підказки або натисніть Enter для продовження: "
  command = gets.chomp.downcase

  return :undo if command == "u"
  return :hint if command == "h"

  row = read_number("Введіть номер рядка (1-#{size}, 0 - вихід): ", size, true)
  return nil if row == 0

  col = read_number("Введіть номер стовпця (1-#{size}): ", size)
  number = read_number("Введіть число (1-#{size}): ", size)

  [row, col, number]
end


def fixed_cell?(initial_board, row, col)
  initial_board[row - 1][col - 1] != 0
end


def row_has_number?(board, row, number)
  board[row - 1].include?(number)
end


def column_has_number?(board, col, number)
  board.each do |row|
    return true if row[col - 1] == number
  end
  false
end


def block_has_number?(board, row, col, number)
  block_size = get_block_size(board)

  start_row = ((row - 1) / block_size) * block_size
  start_col = ((col - 1) / block_size) * block_size

  (start_row...start_row + block_size).each do |r|
    (start_col...start_col + block_size).each do |c|
      return true if board[r][c] == number
    end
  end
  false
end


def make_move(board, row, col, number)
  board[row - 1][col - 1] = number
end


def undo_move(board, move_history)
  if move_history.empty?
    puts "Немає ходів для скасування."
    return false
  end

  row, col, number = move_history.pop
  board[row - 1][col - 1] = 0

  puts "Скасовано хід: рядок #{row}, стовпець #{col}, число #{number}."
  true
end


def board_complete?(board)
  board.each do |row|
    return false if row.include?(0)
  end
  true
end


def display_stats(successful_moves, errors, undos, hints)
  puts "----- Статистика гри -----"
  puts "Успішні ходи: #{successful_moves}"
  puts "Помилки: #{errors}"
  puts "Скасування ходів: #{undos}"
  puts "Використано підказок: #{hints}"
  puts "-------------------------"
end


def show_hint(board, solution_board)
  board.each_with_index do |row, row_index|
    row.each_with_index do |number, col_index|
      if number == 0
        correct_number = solution_board[row_index][col_index]
        puts "Підказка: рядок #{row_index + 1}, стовпець #{col_index + 1}, число #{correct_number}."
        return
      end
    end
  end

  puts "Усі клітинки вже заповнені!"
end


def choose_difficulty
  puts "Оберіть рівень складності:"
  puts "1 - Легкий"
  puts "2 - Середній"
  puts "3 - Складний"

  loop do
    print "Ваш вибір (1-3): "
    choice = gets.chomp

    if choice.match?(/\A[1-3]\z/)
      return choice.to_i
    end

    puts "Помилка! Введіть число від 1 до 3."
  end
end


def choose_board_size
  puts "Оберіть розмір поля:"
  puts "1 - Судоку 4x4"
  puts "2 - Судоку 9x9"

  loop do
    print "Ваш вибір (1-2): "
    choice = gets.chomp

    if choice.match?(/\A[1-2]\z/)
      return choice.to_i
    end

    puts "Помилка! Введіть число 1 або 2."
  end
end


board_size = choose_board_size

if board_size == 1
  difficulty = choose_difficulty
end

if board_size == 1
  if difficulty == 1
    initial_board = [
      [1, 2, 0, 4],
      [3, 4, 1, 0],
      [2, 0, 4, 3],
      [0, 3, 2, 1]
    ]
  elsif difficulty == 2
    initial_board = [
      [1, 0, 0, 4],
      [0, 4, 1, 0],
      [2, 0, 4, 0],
      [0, 3, 0, 1]
    ]
  else
    initial_board = [
      [1, 0, 0, 4],
      [0, 0, 1, 0],
      [2, 0, 0, 0],
      [0, 3, 0, 0]
    ]
  end
else
  initial_board = [
    [5, 3, 0, 0, 7, 0, 0, 0, 0],
    [6, 0, 0, 1, 9, 5, 0, 0, 0],
    [0, 9, 8, 0, 0, 0, 0, 6, 0],
    [8, 0, 0, 0, 6, 0, 0, 0, 3],
    [4, 0, 0, 8, 0, 3, 0, 0, 1],
    [7, 0, 0, 0, 2, 0, 0, 0, 6],
    [0, 6, 0, 0, 0, 0, 2, 8, 0],
    [0, 0, 0, 4, 1, 9, 0, 0, 5],
    [0, 0, 0, 0, 8, 0, 0, 7, 9]
  ]
end

solution_board = [
  [1, 2, 3, 4],
  [3, 4, 1, 2],
  [2, 1, 4, 3],
  [4, 3, 2, 1]
]


solution_board_9x9 = [
  [5, 3, 4, 6, 7, 8, 9, 1, 2],
  [6, 7, 2, 1, 9, 5, 3, 4, 8],
  [1, 9, 8, 3, 4, 2, 5, 6, 7],
  [8, 5, 9, 7, 6, 1, 4, 2, 3],
  [4, 2, 6, 8, 5, 3, 7, 9, 1],
  [7, 1, 3, 9, 2, 4, 8, 5, 6],
  [9, 6, 1, 5, 3, 7, 2, 8, 4],
  [2, 8, 7, 4, 1, 9, 6, 3, 5],
  [3, 4, 5, 2, 8, 6, 1, 7, 9]
]


if board_size == 2
  solution_board = solution_board_9x9
end


board = initial_board.map { |row| row.dup }
move_history = []

successful_moves = 0
errors = 0
undos = 0
hints = 0


loop do
  display_board(board, initial_board)

  move = get_move(board.size)

  if move.nil?
    puts "Гру завершено!"
    break
  elsif move == :undo
    if undo_move(board, move_history)
      undos += 1
    end
    puts
    next
  elsif move == :hint
    show_hint(board, solution_board)
    hints += 1
    puts
    next
  end

  row, col, number = move

  if fixed_cell?(initial_board, row, col)
    puts "Помилка! Початкові числа змінювати не можна."
    errors += 1
  elsif board[row - 1][col - 1] != 0
    puts "Ця клітинка вже заповнена."
    errors += 1
  elsif row_has_number?(board, row, number)
    puts "Помилка! Таке число вже є в цьому рядку."
    errors += 1
  elsif column_has_number?(board, col, number)
    puts "Помилка! Таке число вже є в цьому стовпці."
    errors += 1
  elsif block_has_number?(board, row, col, number)
    puts "Помилка! Таке число вже є в цьому блоці."
    errors += 1
  else
    make_move(board, row, col, number)
    move_history.push([row, col, number])
    successful_moves += 1
    puts "Число #{number} успішно записано!"

    if board_complete?(board)
      display_board(board, initial_board)
      puts "Вітаємо! Ви правильно заповнили все поле Судоку!"
      break
    end
  end
  puts
end

display_stats(successful_moves, errors, undos, hints)

