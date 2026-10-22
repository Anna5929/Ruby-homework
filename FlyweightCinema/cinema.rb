require_relative 'seat_type_factory'
require_relative 'seat'

class Cinema
  attr_reader :seats, :seat_type_factory

  def initialize
    @seats = []
    @seat_type_factory = SeatTypeFactory.new
  end

  def add_seat(hall_number, row_number, seat_number, category)
    properties = seat_properties(category)

    seat_type = @seat_type_factory.get_seat_type(
      properties[:name],
      properties[:material],
      properties[:width],
      properties[:legroom],
      properties[:reclining],
      properties[:description]
    )

    seat = Seat.new(hall_number, row_number, seat_number, seat_type)
    @seats << seat

    seat
  end

  def find_seat(hall_number, row_number, seat_number)
    @seats.find do |seat|
      seat.hall_number == hall_number &&
        seat.row_number == row_number &&
        seat.seat_number == seat_number
    end
  end

  def book_seat(hall_number, row_number, seat_number)
    seat = find_seat(hall_number, row_number, seat_number)
    return false if seat.nil?

    seat.book!
  end

  private

  def seat_properties(category)
    case category
    when :standard
      {
        name: "Standard",
        material: "Тканина",
        width: 50,
        legroom: 75,
        reclining: false,
        description: "Зручне стандартне крісло для перегляду фільмів."
      }
    when :comfort
      {
        name: "Comfort",
        material: "Екошкіра",
        width: 65,
        legroom: 95,
        reclining: true,
        description: "Крісло підвищеного комфорту з регульованою спинкою."
      }
    when :vip
      {
        name: "VIP",
        material: "Натуральна шкіра",
        width: 85,
        legroom: 120,
        reclining: true,
        description: "Просторе преміальне крісло з максимальним комфортом."
      }
    else
      raise ArgumentError, "Невідома категорія крісла: #{category}"
    end
  end
end
