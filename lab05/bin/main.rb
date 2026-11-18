require_relative '../lib/expense_tracker'

path = File.expand_path('../data/expenses.json', __dir__)

begin
  storage = ExpenseStorage.new(path)
  manager = ExpenseManager.new(storage)
  tracker = ExpenseTracker.new(manager)

  tracker.run

rescue ArgumentError, SystemCallError, IOError => e
  warn "Помилка: #{e.message}"
  exit 1
end
