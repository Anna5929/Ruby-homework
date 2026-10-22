class Seat
  attr_reader :hall_number, :row_number, :seat_number, :seat_type

  def initialize(hall_number, row_number, seat_number, seat_type)
    @hall_number = hall_number
    @row_number = row_number
    @seat_number = seat_number
    @seat_type = seat_type
    @booked = false
  end

  def booked?
    @booked
  end

  def book!
    return false if booked?

    @booked = true
    true
  end

  def cancel_booking!
    return false unless booked?

    @booked = false
    true
  end

  def display_info
    info = @seat_type.display_info(
      @hall_number, @row_number, @seat_number
    )

    status = booked? ? "Заброньовано" : "Вільне"

    "#{info}\nСтатус: #{status}"
  end
end
