require_relative 'expense_manager'

class ExpenseTracker
  def initialize(manager)
    @manager = manager
  end

  def run
    loop do
      show_menu

      print "Оберіть дію: "
      choice = gets&.strip

      if choice.nil?
        puts "\nЗавершення роботи."
        break
      end

      case choice
      when '1'
        add_expense
      when '2'
        show_all_expenses
      when '3'
        filter_expenses
      when '4'
        delete_expense
      when '5'
        show_statistics
      when '6'
        import_expenses
      when '0'
        puts "Дякуємо за використання ExpenseTracker!"
        break
      else
        puts "Невідома команда. Оберіть пункт від 0 до 6."
      end
    end
  end

  private

  def show_menu
    puts "\n========== EXPENSE TRACKER =========="
    puts "1. Додати витрату"
    puts "2. Переглянути всі витрати"
    puts "3. Фільтрувати витрати"
    puts "4. Видалити витрату"
    puts "5. Переглянути статистику"
    puts "6. Імпортувати витрати з JSON"
    puts "0. Вийти"
    puts "====================================="
  end

  def add_expense
    puts "\n========== ДОДАВАННЯ ВИТРАТИ =========="

    print "Дата (YYYY-MM-DD): "
    date = gets&.strip
    return if date.nil?

    print "Сума в копійках: "
    amount_input = gets&.strip
    return if amount_input.nil?

    begin
      amount = Integer(amount_input, 10)
    rescue ArgumentError
      puts "Помилка: сума повинна бути цілим числом копійок."
      return
    end

    category = choose_category
    return if category.nil?

    print "Опис: "
    description = gets&.strip
    return if description.nil?

    begin
      expense = @manager.add_expense(
        date: date,
        amount_in_kopecks: amount,
        category: category,
        description: description
      )

      puts "Витрату з ID #{expense.id} успішно додано!"
    rescue ArgumentError => e
      puts "Помилка: #{e.message}"
    rescue SystemCallError, IOError => e
      puts "Не вдалося зберегти витрату: #{e.message}"
    end
  end

  def show_all_expenses
    puts "\n========== УСІ ВИТРАТИ =========="

    expenses = @manager.all_expenses

    if expenses.empty?
      puts "Список витрат порожній."
      puts "Загальна сума: 0.00 грн"
      return
    end

    print_expenses_table(expenses)

    total = expenses.sum(&:amount_in_kopecks)
    puts "Загальна сума: #{format_money(total)} грн"
  end

  def print_expenses_table(expenses)
    printf "%-5s | %-10s | %12s | %-15s | %s\n",
           "ID", "Дата", "Сума (грн)", "Категорія", "Опис"

    puts "-" * 85

    expenses.each do |expense|
      printf "%-5d | %-10s | %12s | %-15s | %s\n",
             expense.id,
             expense.date,
             format_money(expense.amount_in_kopecks),
             expense.category,
             expense.description
    end

    puts "-" * 85
  end

  def format_money(kopecks)
    hryvnias = kopecks / 100
    remainder = kopecks % 100

    format('%d.%02d', hryvnias, remainder)
  end

  def filter_expenses
    puts "\n========== ФІЛЬТРАЦІЯ ВИТРАТ =========="
    puts "1. За категорією"
    puts "2. За періодом"
    puts "3. За категорією та періодом"
    puts "0. Повернутися до головного меню"

    print "Оберіть дію: "
    choice = gets&.strip
    return if choice.nil? || choice == '0'

    unless %w[1 2 3].include?(choice)
      puts "Помилка: оберіть пункт від 0 до 3."
      return
    end

    category = nil
    start_date = nil
    end_date = nil

    if choice == '1' || choice == '3'
      category = choose_category
      return if category.nil?
    end

    if choice == '2' || choice == '3'
      print "Початкова дата (YYYY-MM-DD): "
      start_date = gets&.strip
      return if start_date.nil?

      print "Кінцева дата (YYYY-MM-DD): "
      end_date = gets&.strip
      return if end_date.nil?
    end

    begin
      expenses = @manager.filter_expenses(
        category: category,
        start_date: start_date,
        end_date: end_date
      )

      if expenses.empty?
        puts "Витрат за заданими критеріями не знайдено."
        puts "Загальна сума: 0.00 грн"
      else
        print_expenses_table(expenses)

        total = expenses.sum(&:amount_in_kopecks)
        puts "Загальна сума: #{format_money(total)} грн"
      end

    rescue ArgumentError => e
      puts "Помилка: #{e.message}"
    end
  end

  def choose_category
    puts "\nОберіть категорію:"
    puts "1. Їжа"
    puts "2. Транспорт"
    puts "3. Навчання"
    puts "4. Розваги"
    puts "5. Інше"

    print "Ваш вибір: "
    choice = gets&.strip

    categories = {
      '1' => 'food',
      '2' => 'transport',
      '3' => 'study',
      '4' => 'entertainment',
      '5' => 'other'
    }

    category = categories[choice]

    puts "Помилка: оберіть категорію від 1 до 5." unless category

    category
  end

  def delete_expense
    puts "\n========== ВИДАЛЕННЯ ВИТРАТИ =========="

    print "Введіть ID витрати: "
    id_input = gets&.strip
    return if id_input.nil?

    begin
      begin
        id = Integer(id_input, 10)
      rescue ArgumentError
        puts "Помилка: ID повинен бути додатним цілим числом."
        return
      end

      unless id.positive?
        puts "Помилка: ID повинен бути додатним цілим числом."
        return
      end

      expense = @manager.find_expense(id)

      unless expense
        puts "Витрату з ID #{id} не знайдено."
        return
      end

      puts "\nЗнайдено витрату:"
      puts "ID: #{expense.id}"
      puts "Дата: #{expense.date}"
      puts "Сума: #{format_money(expense.amount_in_kopecks)} грн"
      puts "Категорія: #{expense.category}"
      puts "Опис: #{expense.description}"

      print "\nВидалити цю витрату? (так/ні): "
      confirmation = gets&.strip&.downcase

      if confirmation == 'так'
        @manager.delete_expense(id)
        puts "Витрату з ID #{id} успішно видалено!"
      elsif confirmation == 'ні'
        puts "Видалення скасовано."
      else
        puts "Невідповідне підтвердження. Видалення скасовано."
      end

    rescue ArgumentError => e
      puts "Помилка: #{e.message}"
    rescue SystemCallError, IOError => e
      puts "Не вдалося зберегти зміни: #{e.message}"
    end
  end

  def show_statistics
    puts "\n========== СТАТИСТИКА ВИТРАТ =========="

    puts "\nЗагальна сума всіх витрат:"
    puts "#{format_money(@manager.total_amount)} грн"

    puts "\nСуми за категоріями:"

    @manager.totals_by_category.each do |category, amount|
      puts "#{category}: #{format_money(amount)} грн"
    end

    puts "\nНайбільші витрати:"

    largest = @manager.largest_expenses

    if largest.empty?
      puts "Витрат немає."
    else
      print_expenses_table(largest)
    end

    puts "\nПереглянути суму за певний період? (так/ні): "
    choice = gets&.strip&.downcase

    return unless choice == 'так'

    print "Початкова дата (YYYY-MM-DD): "
    start_date = gets&.strip
    return if start_date.nil?

    print "Кінцева дата (YYYY-MM-DD): "
    end_date = gets&.strip
    return if end_date.nil?

    begin
      total = @manager.total_for_period(
        start_date: start_date,
        end_date: end_date
      )

      puts "Загальна сума за період: #{format_money(total)} грн"

      if total.zero?
        puts "Витрат за заданий період не знайдено."
      end

    rescue ArgumentError => e
      puts "Помилка: #{e.message}"
    end
  end

  def import_expenses
    puts "\n========== ІМПОРТ ВИТРАТ =========="

    print "Введіть шлях до JSON-файлу: "
    path = gets&.strip
    return if path.nil?

    if path.empty?
      puts "Помилка: шлях до файлу не може бути порожнім."
      return
    end

    begin
      count = @manager.import_expenses(path)

      if count.zero?
        puts "Файл не містить витрат для імпорту."
      else
        puts "Успішно імпортовано витрат: #{count}"
      end

    rescue ArgumentError => e
      puts "Помилка імпорту: #{e.message}"
    rescue SystemCallError, IOError => e
      puts "Помилка роботи з файлом: #{e.message}"
    end
  end
end
