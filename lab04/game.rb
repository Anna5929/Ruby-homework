require 'set'

require_relative 'game_constants'
require_relative 'board'
require_relative 'errors'

class Game
  include GameConstants

  def initialize
    @player_board = Board.new
    @computer_board = Board.new
    @computer_shots = Set.new
  end

  def play
    puts "\n=== НОВА ГРА: МОРСЬКИЙ БІЙ ==="
    puts 'Для пострілу введіть координати, наприклад A1 або J10.'
    puts 'Щоб завершити поточну гру, введіть 0.'

    loop do
      show_boards

      player_result = player_turn
      return :quit if player_result == :quit

      if @computer_board.all_ships_sunk?
        show_result(true)
        return :win
      end

      computer_turn

      if @player_board.all_ships_sunk?
        show_result(false)
        return :loss
      end
    end
  end

  private

  def show_boards
    puts "\n--- ВАШЕ ПОЛЕ ---"
    @player_board.display(reveal_ships: true)

    puts "\n--- ПОЛЕ КОМП'ЮТЕРА ---"
    @computer_board.display
  end

  def player_turn
    loop do
      print "\nВаш постріл: "
      input = gets

      return :quit if input.nil?

      input = input.strip.upcase
      return :quit if input == '0'

      begin
        row, column = parse_coordinates(input)
        result = @computer_board.receive_shot(row, column)

        puts result_message(result)
        return result
      rescue InvalidCoordinateError, RepeatedShotError => error
        puts "Помилка: #{error.message}"
        puts 'Спробуйте ще раз.'
      end
    end
  end

  def computer_turn
    row, column = choose_computer_shot

    puts "\nКомп'ютер стріляє: #{coordinate_name(row, column)}"

    result = @player_board.receive_shot(row, column)

    puts result_message(result)
  end

  def parse_coordinates(input)
    match = /\A([A-J])(10|[1-9])\z/.match(input)

    unless match
      raise InvalidCoordinateError,
            'Введіть координати від A1 до J10, наприклад B5.'
    end

    column = match[1].ord - 'A'.ord
    row = match[2].to_i - 1

    [row, column]
  end

  def choose_computer_shot
    available = (0...BOARD_SIZE).to_a.product(
      (0...BOARD_SIZE).to_a
    ).reject do |position|
      @computer_shots.include?(position)
    end

    position = available.sample

    @computer_shots.add(position)

    position
  end

  def coordinate_name(row, column)
    letter = ('A'.ord + column).chr
    "#{letter}#{row + 1}"
  end

  def result_message(result)
    case result
    when :miss
      'Промах!'
    when :hit
      'Влучання!'
    when :sunk
      'Корабель знищено!'
    end
  end

  def show_result(player_won)
    puts "\n=== ГРУ ЗАВЕРШЕНО ==="

    if player_won
      puts 'Вітаємо! Ви знищили всі кораблі комп’ютера!'
    else
      puts 'Комп’ютер переміг! Усі ваші кораблі знищено.'
    end

    puts "\n--- ВАШЕ ПОЛЕ ---"
    @player_board.display(reveal_ships: true)

    puts "\n--- ПОЛЕ КОМП'ЮТЕРА ---"
    @computer_board.display(reveal_ships: true)
  end
end