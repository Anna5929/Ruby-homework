require_relative 'game'
require_relative 'statistics'

def show_rules
  puts "\n=== ПРАВИЛА ГРИ ==="
  puts '1. Ігрове поле має розмір 10×10.'
  puts '2. Кожен учасник має 10 кораблів:'
  puts '   - 1 чотирипалубний;'
  puts '   - 2 трипалубні;'
  puts '   - 3 двопалубні;'
  puts '   - 4 однопалубні.'
  puts '3. Кораблі не можуть перетинатися або торкатися один одного.'
  puts '4. Гравець і комп’ютер стріляють по черзі.'
  puts '5. Для пострілу введіть координати від A1 до J10.'
  puts '6. Повторний постріл в одну клітинку заборонений.'
  puts '7. Перемагає той, хто першим знищить усі кораблі суперника.'
  puts '8. Під час гри введіть 0, щоб повернутися до меню.'

  puts "\nПозначення на полі:"
  puts '. - невідома клітинка'
  puts 'S - корабель'
  puts 'X - влучання'
  puts '# - знищений корабель'
  puts 'o - промах'
end

def show_menu
  puts "\n========== МОРСЬКИЙ БІЙ =========="
  puts '1. Нова гра'
  puts '2. Правила гри'
  puts '3. Статистика'
  puts '0. Вихід'
  print 'Оберіть пункт меню: '
end

statistics = Statistics.new

loop do
  show_menu

  input = gets
  break if input.nil?

  choice = input.strip

  case choice
  when '1'
    game = Game.new
    result = game.play

    statistics.record_result(result)

    if result == :quit
      puts "\nВи повернулися до головного меню."
    end

  when '2'
    show_rules

  when '3'
    statistics.display

  when '0'
    puts "\nДякуємо за гру! До зустрічі!"
    break

  else
    puts "\nНевідомий пункт меню. Спробуйте ще раз."
  end
end
