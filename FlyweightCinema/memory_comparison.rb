require 'objspace'
require_relative 'cinema'

# Створюємо кінотеатр із використанням Flyweight
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

# Обчислюємо пам'ять для спільних характеристик
shared_types = cinema.seats.map(&:seat_type).uniq

flyweight_memory = shared_types.sum do |seat_type|
  ObjectSpace.memsize_of(seat_type) +
    ObjectSpace.memsize_of(seat_type.name) +
    ObjectSpace.memsize_of(seat_type.material) +
    ObjectSpace.memsize_of(seat_type.description)
end

# Моделюємо підхід без Flyweight:
# кожне місце отримує власні копії характеристик
ordinary_seat_data = cinema.seats.map do |seat|
  seat_type = seat.seat_type

  {
    name: seat_type.name.dup,
    material: seat_type.material.dup,
    width: seat_type.width,
    legroom: seat_type.legroom,
    reclining: seat_type.reclining,
    description: seat_type.description.dup
  }
end

ordinary_memory = ordinary_seat_data.sum do |data|
  ObjectSpace.memsize_of(data) +
    ObjectSpace.memsize_of(data[:name]) +
    ObjectSpace.memsize_of(data[:material]) +
    ObjectSpace.memsize_of(data[:description])
end

saved_memory = ordinary_memory - flyweight_memory
saved_percent = saved_memory.to_f / ordinary_memory * 100

puts "=== ПОРІВНЯННЯ ПАМ'ЯТІ ==="
puts "Кількість місць: #{cinema.seats.size}"
puts "Кількість спільних типів: #{shared_types.size}"

puts "\nБез Flyweight: #{ordinary_memory} байт"
puts "З Flyweight: #{flyweight_memory} байт"
puts "Економія: #{saved_memory} байт"
puts "Економія: #{saved_percent.round(2)}%"
