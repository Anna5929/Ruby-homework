choices = ["Камінь", "Ножиці", "Папір"]

user_wins = 0
computer_wins = 0
draws = 0
rounds = 0

loop do
  user_choice_number = nil

  loop do
    puts "Оберіть:"
    puts "1 - Камінь"
    puts "2 - Ножиці"
    puts "3 - Папір"

    user_choice_number = gets.chomp.to_i

    if user_choice_number >= 1 && user_choice_number <= 3
      break
    else
      puts "Невірний вибір. Введіть число 1, 2 або 3."
    end
  end

  user_choice = choices[user_choice_number - 1]

  computer_choice = choices.sample

  puts "Ваш вибір: #{user_choice}"
  puts "Вибір комп'ютера: #{computer_choice}"

  if user_choice == computer_choice
    puts "Нічия!"
    draws += 1

  elsif (user_choice == "Камінь" && computer_choice == "Ножиці") ||
        (user_choice == "Ножиці" && computer_choice == "Папір") ||
        (user_choice == "Папір" && computer_choice == "Камінь")
    puts "Ви перемогли!"
    user_wins += 1

  else
    puts "Комп'ютер переміг!"
    computer_wins += 1
  end

  rounds += 1

  puts
  puts "Статистика:"
  puts "Ваші перемоги: #{user_wins}"
  puts "Перемоги комп'ютера: #{computer_wins}"
  puts "Нічиї: #{draws}"
  puts "Зіграно раундів: #{rounds}"
  puts

  answer = nil

  loop do
    puts "Продовжити гру?"
    puts "1 - Так"
    puts "0 - Ні"

    answer = gets.chomp

    if answer == "1" || answer == "0"
      break
    else
      puts "Невірний вибір. Введіть 1 або 0."
    end
  end

  puts

  break if answer == "0"
end