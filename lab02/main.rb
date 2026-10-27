def prepare_cake(cake)
  rows = cake
           .tr("оО", "oo")
           .split("\n")
           .map { |row| row.gsub(/[ \t]/, "") }
           .reject(&:empty?)

  return nil if rows.empty?

  height = rows.length
  width = rows.first.length

  return nil if width.zero?
  return nil unless rows.all? { |row| row.length == width }
  return nil unless rows.all? { |row| row.match?(/\A[.o]+\z/) }

  raisins = rows.sum { |row| row.count("o") }

  return nil unless (2..9).include?(raisins)

  total_area = width * height

  return nil unless (total_area % raisins).zero?

  piece_area = total_area / raisins

  {
    rows: rows,
    width: width,
    height: height,
    raisins: raisins,
    piece_area: piece_area
  }
end


def valid_piece?(rows, used, x, y, width, height)
  raisins = 0

  (y...(y + height)).each do |row|
    (x...(x + width)).each do |col|
      return false if used[row][col]

      raisins += 1 if rows[row][col] == "o"
    end
  end

  raisins == 1
end


def find_pieces(rows, used, piece_area, pieces = [])
  height = rows.length
  width = rows.first.length

  first_free = nil

  (0...height).each do |y|
    (0...width).each do |x|
      unless used[y][x]
        first_free = [x, y]
        break
      end
    end

    break if first_free
  end

  return pieces.dup if first_free.nil?

  x, y = first_free

  piece_area.downto(1) do |piece_width|
    next unless (piece_area % piece_width).zero?

    piece_height = piece_area / piece_width

    next if x + piece_width > width
    next if y + piece_height > height

    next unless valid_piece?(
      rows, used, x, y, piece_width, piece_height
    )

    (y...(y + piece_height)).each do |row|
      (x...(x + piece_width)).each do |col|
        used[row][col] = true
      end
    end

    pieces << [x, y, piece_width, piece_height]

    result = find_pieces(rows, used, piece_area, pieces)

    return result unless result.nil?

    pieces.pop

    (y...(y + piece_height)).each do |row|
      (x...(x + piece_width)).each do |col|
        used[row][col] = false
      end
    end
  end

  nil
end


def cut_cake(cake)
  data = prepare_cake(cake)

  return [] if data.nil?

  rows = data[:rows]
  width = data[:width]
  height = data[:height]
  piece_area = data[:piece_area]

  used = Array.new(height) { Array.new(width, false) }

  pieces = find_pieces(rows, used, piece_area)

  return [] if pieces.nil?

  pieces.map do |x, y, piece_width, piece_height|
    (y...(y + piece_height)).map do |row|
      rows[row][x, piece_width]
    end.join("\n")
  end
end


if __FILE__ == $PROGRAM_NAME
  puts "=== Пиріг із родзинками ==="
  puts "Вставте пиріг цілком."
  puts "Використовуйте '.' для тіста та 'o' для родзинок."
  puts "Для завершення введення натисніть Enter на порожньому рядку."
  puts

  cake_rows = []

  loop do
    line = gets

    break if line.nil? || line.strip.empty?

    cake_rows << line.strip
  end

  cake = cake_rows.join("\n")
  result = cut_cake(cake)

  if result.empty?
    puts "\nНе вдалося знайти правильне розрізання пирога."
  else
    puts "\nЗнайдено #{result.length} шматочків:"

    result.each_with_index do |piece, index|
      puts "\nШматочок #{index + 1}:"
      puts piece
    end
  end
end

