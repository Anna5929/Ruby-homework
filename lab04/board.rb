require_relative 'game_constants'
require_relative 'ship'
require_relative 'errors'

class Board
  include GameConstants

  attr_reader :ships

  def initialize
    @ships = []
    @shots = {}

    place_fleet
  end

  def receive_shot(row, column)
    validate_coordinates!(row, column)

    position = [row, column]

    if @shots.key?(position)
      raise RepeatedShotError, 'Ви вже стріляли в цю клітинку.'
    end

    ship = ship_at(row, column)

    if ship.nil?
      @shots[position] = :miss
      return :miss
    end

    ship.hit!(row, column)

    if ship.sunk?
      @shots[position] = :sunk
      :sunk
    else
      @shots[position] = :hit
      :hit
    end
  end

  def all_ships_sunk?
    @ships.all?(&:sunk?)
  end

  def cell_state(row, column, reveal_ships: false)
    position = [row, column]
    ship = ship_at(row, column)

    if @shots.key?(position)
      return :miss if @shots[position] == :miss
      return :sunk if ship.sunk?

      return :hit
    end

    return :ship if reveal_ships && ship

    :unknown
  end

  def display(reveal_ships: false)
    puts "    #{('A'..'J').to_a.join('  ')}"

    BOARD_SIZE.times do |row|
      print format('%2d  ', row + 1)

      BOARD_SIZE.times do |column|
        state = cell_state(row, column, reveal_ships: reveal_ships)

        symbol = case state
                 when :ship then 'S'
                 when :hit then 'X'
                 when :sunk then '#'
                 when :miss then 'o'
                 else '.'
                 end

        print "#{symbol}  "
      end

      puts
    end
  end

  private

  def place_fleet
    FLEET.each do |size|
      place_ship(size)
    end
  end

  def place_ship(size)
    loop do
      horizontal = [true, false].sample

      row = rand(BOARD_SIZE)
      column = rand(BOARD_SIZE)

      positions = build_positions(row, column, size, horizontal)

      next unless valid_ship_position?(positions)

      @ships << Ship.new(size, positions)
      break
    end
  end

  def build_positions(row, column, size, horizontal)
    Array.new(size) do |index|
      if horizontal
        [row, column + index]
      else
        [row + index, column]
      end
    end
  end

  def valid_ship_position?(positions)
    positions.all? do |row, column|
      inside_board?(row, column) &&
        ship_at(row, column).nil? &&
        neighbours_free?(row, column)
    end
  end

  def neighbours_free?(row, column)
    (-1..1).all? do |row_offset|
      (-1..1).all? do |column_offset|
        neighbour_row = row + row_offset
        neighbour_column = column + column_offset

        next true unless inside_board?(neighbour_row, neighbour_column)

        ship_at(neighbour_row, neighbour_column).nil?
      end
    end
  end

  def ship_at(row, column)
    @ships.find do |ship|
      ship.occupies?(row, column)
    end
  end

  def inside_board?(row, column)
    row.between?(0, BOARD_SIZE - 1) &&
      column.between?(0, BOARD_SIZE - 1)
  end

  def validate_coordinates!(row, column)
    return if inside_board?(row, column)

    raise InvalidCoordinateError, 'Координати виходять за межі ігрового поля.'
  end
end