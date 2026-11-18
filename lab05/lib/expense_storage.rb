require 'json'
require 'tempfile'
require_relative 'expense'

class ExpenseStorage
  def initialize(path)
    @path = path
  end

  def load
    return [] unless File.exist?(@path)

    content = File.read(@path, encoding: 'UTF-8')
    data = JSON.parse(content)

    unless data.is_a?(Array)
      raise ArgumentError, "JSON-файл повинен містити масив витрат."
    end

    expenses = data.map do |item|
      unless item.is_a?(Hash)
        raise ArgumentError, "Кожна витрата повинна бути об'єктом JSON."
      end

      Expense.new(
        id: item.fetch('id'),
        date: item.fetch('date'),
        amount_in_kopecks: item.fetch('amount_in_kopecks'),
        category: item.fetch('category'),
        description: item.fetch('description')
      )
    end

    ids = expenses.map(&:id)

    unless ids.uniq.length == ids.length
      raise ArgumentError, "У JSON-файлі знайдено повторювані ID."
    end

    expenses

  rescue JSON::ParserError
    raise ArgumentError, "JSON-файл порожній або пошкоджений."
  rescue KeyError => e
    raise ArgumentError, "У записі відсутнє обов'язкове поле: #{e.key}."
  end

  def save(expenses)
    data = expenses.map do |expense|
      {
        id: expense.id,
        date: expense.date,
        amount_in_kopecks: expense.amount_in_kopecks,
        category: expense.category,
        description: expense.description
      }
    end

    directory = File.dirname(@path)
    temp_file = Tempfile.new(['expenses', '.tmp'], directory)
    temp_path = temp_file.path

    begin
      temp_file.write(JSON.pretty_generate(data))
      temp_file.flush
      temp_file.fsync
      temp_file.close

      File.rename(temp_path, @path)
    ensure
      temp_file.close unless temp_file.closed?
      File.delete(temp_path) if File.exist?(temp_path)
    end
  end
end
