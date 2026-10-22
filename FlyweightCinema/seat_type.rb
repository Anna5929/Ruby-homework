class SeatType
  attr_reader :name, :material, :width, :legroom, :reclining, :description

  def initialize(name, material, width, legroom, reclining, description)
    @name = name.dup.freeze
    @material = material.dup.freeze
    @width = width
    @legroom = legroom
    @reclining = reclining
    @description = description.dup.freeze

    freeze
  end

  def display_info(hall_number, row_number, seat_number)
    "Зал #{hall_number}, ряд #{row_number}, місце #{seat_number}\n" \
      "Категорія: #{@name}\n" \
      "Матеріал: #{@material}\n" \
      "Ширина крісла: #{@width} см\n" \
      "Простір для ніг: #{@legroom} см\n" \
      "Регулювання спинки: #{@reclining ? 'Так' : 'Ні'}\n" \
      "Опис: #{@description}"
  end
end
