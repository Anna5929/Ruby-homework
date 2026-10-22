require_relative 'seat_type'

class SeatTypeFactory
  def initialize
    @seat_types = {}
  end

  def get_seat_type(name, material, width, legroom, reclining, description)
    key = [
      name.dup.freeze,
      material.dup.freeze,
      width,
      legroom,
      reclining,
      description.dup.freeze
    ].freeze

    unless @seat_types.key?(key)
      @seat_types[key] = SeatType.new(
        name, material, width, legroom, reclining, description
      )
    end

    @seat_types[key]
  end

  def count
    @seat_types.size
  end
end
