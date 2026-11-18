require_relative 'expense'
require_relative 'expense_storage'

class ExpenseManager
  def initialize(storage)
    @storage = storage
    @expenses = @storage.load
  end

  def add_expense(date:, amount_in_kopecks:, category:, description:)
    next_id = (@expenses.map(&:id).max || 0) + 1

    expense = Expense.new(
      id: next_id,
      date: date,
      amount_in_kopecks: amount_in_kopecks,
      category: category,
      description: description
    )

    updated_expenses = @expenses + [expense]

    @storage.save(updated_expenses)
    @expenses = updated_expenses

    expense
  end

  def all_expenses
    @expenses.sort_by { |expense| [expense.date, -expense.id] }.reverse
  end

  def delete_expense(id)
    expense = @expenses.find { |item| item.id == id }

    return nil unless expense

    updated_expenses = @expenses.reject { |item| item.id == id }

    @storage.save(updated_expenses)
    @expenses = updated_expenses

    expense
  end

  def find_expense(id)
    @expenses.find { |expense| expense.id == id }
  end

  def filter_expenses(category: nil, start_date: nil, end_date: nil)
    if category && !Expense::CATEGORIES.include?(category)
      raise ArgumentError, "Недопустима категорія витрати."
    end

    [start_date, end_date].compact.each do |date|
      Expense.validate_date(date)
    end

    if start_date && end_date && start_date > end_date
      raise ArgumentError, "Початкова дата не може бути пізнішою за кінцеву."
    end

    result = @expenses.select do |expense|
      matches_category = category.nil? || expense.category == category
      matches_start = start_date.nil? || expense.date >= start_date
      matches_end = end_date.nil? || expense.date <= end_date

      matches_category && matches_start && matches_end
    end

    result.sort_by { |expense| [expense.date, -expense.id] }.reverse
  end

  def total_amount
    @expenses.sum(&:amount_in_kopecks)
  end

  def totals_by_category
    totals = Expense::CATEGORIES.to_h { |category| [category, 0] }

    @expenses.each do |expense|
      totals[expense.category] += expense.amount_in_kopecks
    end

    totals
  end

  def largest_expenses
    return [] if @expenses.empty?

    max_amount = @expenses.map(&:amount_in_kopecks).max

    @expenses.select do |expense|
      expense.amount_in_kopecks == max_amount
    end.sort_by { |expense| [expense.date, -expense.id] }.reverse
  end

  def total_for_period(start_date:, end_date:)
    raise ArgumentError, "Необхідно вказати обидві дати." if start_date.nil? || end_date.nil?

    expenses = filter_expenses(start_date: start_date, end_date: end_date)
    expenses.sum(&:amount_in_kopecks)
  end

  def import_expenses(path)
    unless File.file?(path)
      raise ArgumentError, "Файл для імпорту не знайдено."
    end

    imported_storage = ExpenseStorage.new(path)
    imported_expenses = imported_storage.load

    return 0 if imported_expenses.empty?

    next_id = (@expenses.map(&:id).max || 0) + 1

    new_expenses = imported_expenses.map do |expense|
      new_expense = Expense.new(
        id: next_id,
        date: expense.date,
        amount_in_kopecks: expense.amount_in_kopecks,
        category: expense.category,
        description: expense.description
      )

      next_id += 1
      new_expense
    end

    updated_expenses = @expenses + new_expenses

    @storage.save(updated_expenses)
    @expenses = updated_expenses

    new_expenses.length
  end
end
