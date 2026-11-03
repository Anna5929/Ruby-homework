class Ship
  attr_reader :size, :positions

  def initialize(size, positions)
    @size = size
    @positions = positions
    @hits = []
  end

  def occupies?(row, column)
    @positions.include?([row, column])
  end

  def hit!(row, column)
    position = [row, column]

    @hits << position if occupies?(row, column) && !@hits.include?(position)
  end

  def hit?(row, column)
    @hits.include?([row, column])
  end

  def sunk?
    @positions.all? { |position| @hits.include?(position) }
  end
end