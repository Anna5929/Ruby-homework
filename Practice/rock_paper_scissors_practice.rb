choices = ["Камінь", "Ножиці", "Папір"]

user_wins = 0
computer_wins = 0
draws = 0
rounds = 0

loop do
  puts "Оберіть: Камінь, Ножиці або Папір"
  user_choice = gets.chomp

  computer_choice = choices.sample

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

  puts "Статистика:"
  puts "Ваші перемоги: #{user_wins}"
  puts "Перемоги комп'ютера: #{computer_wins}"
  puts "Нічиї: #{draws}"
  puts "Зіграно раундів: #{rounds}"

  puts "Зіграти ще раз? (так/ні)"
  answer = gets.chomp.downcase

  break if answer == "ні"
end