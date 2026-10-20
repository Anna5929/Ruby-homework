def display_board(board, initial_board)
  puts "    1 2   3 4"
  puts "  +-----+-----+"

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
      print "| " if col_index == 1
    end

    puts "|"
    puts "  +-----+-----+" if row_index == 1 || row_index == 3
  end
end


def read_number(message, allow_zero = false)
  loop do
    print message
    input = gets.chomp

    if allow_zero && input == "0"
      return 0
    end

    if input.match?(/\A[1-4]\z/)
      return input.to_i
    end

    puts "Помилка! Введіть допустиме число."
  end
end


def get_move
  row = read_number("Введіть номер рядка (1-4, 0 - вихід): ", true)

  return nil if row == 0

  col = read_number("Введіть номер стовпця (1-4): ")
  number = read_number("Введіть число (1-4): ")

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
  start_row = ((row - 1) / 2) * 2
  start_col = ((col - 1) / 2) * 2

  (start_row...start_row + 2).each do |r|
    (start_col...start_col + 2).each do |c|
      return true if board[r][c] == number
    end
  end

  false
end


def make_move(board, row, col, number)
  board[row - 1][col - 1] = number
end


def board_complete?(board)
  board.each do |row|
    return false if row.include?(0)
  end

  true
end


initial_board = [
  [1, 0, 0, 4],
  [0, 4, 1, 0],
  [2, 0, 4, 0],
  [0, 3, 0, 1]
]

board = initial_board.map { |row| row.dup }


loop do
  display_board(board, initial_board)

  move = get_move

  if move.nil?
    puts "Гру завершено!"
    break
  end

  row, col, number = move


  if fixed_cell?(initial_board, row, col)
    puts "Помилка! Початкові числа змінювати не можна."
  elsif board[row - 1][col - 1] != 0
    puts "Ця клітинка вже заповнена."
  elsif row_has_number?(board, row, number)
    puts "Помилка! Таке число вже є в цьому рядку."
  elsif column_has_number?(board, col, number)
    puts "Помилка! Таке число вже є в цьому стовпці."
  elsif block_has_number?(board, row, col, number)
    puts "Помилка! Таке число вже є в цьому блоці 2x2."
  else
    make_move(board, row, col, number)
    puts "Число #{number} успішно записано!"

    if board_complete?(board)
      display_board(board, initial_board)
      puts "Вітаємо! Ви правильно заповнили все поле Судоку!"
      break
    end
  end


  puts
end
