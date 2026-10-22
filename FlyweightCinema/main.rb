require_relative 'cinema'

cinema = Cinema.new

1.upto(5) do |hall|
  1.upto(10) do |row|
    1.upto(20) do |seat_number|
      category = if row <= 6
                   :standard
                 elsif row <= 9
                   :comfort
                 else
                   :vip
                 end

      cinema.add_seat(hall, row, seat_number, category)
    end
  end
end

puts "=== СИСТЕМА КІНОТЕАТРУ ==="
puts "Кількість залів: 5"
puts "Загальна кількість місць: #{cinema.seats.size}"
puts "Кількість створених типів крісел: #{cinema.seat_type_factory.count}"

puts "\n=== ІНФОРМАЦІЯ ПРО МІСЦЕ ==="

seat = cinema.find_seat(2, 10, 12)
puts seat.display_info

puts "\n=== БРОНЮВАННЯ ==="

puts "Бронювання місця: #{cinema.book_seat(2, 10, 12)}"
puts "Повторне бронювання: #{cinema.book_seat(2, 10, 12)}"
puts "Статус місця: #{seat.booked? ? 'Заброньовано' : 'Вільне'}"

puts "\n=== ПЕРЕВІРКА ЛЕГКОВАГОВИКА ==="

seat1 = cinema.find_seat(1, 10, 1)
seat2 = cinema.find_seat(5, 10, 20)
seat3 = cinema.find_seat(1, 1, 1)

puts "Два VIP-місця використовують один SeatType: #{seat1.seat_type.equal?(seat2.seat_type)}"
puts "VIP і Standard використовують один SeatType: #{seat1.seat_type.equal?(seat3.seat_type)}"
