def play_game
  secret_number = rand(1..100)
  attempts = 0

  loop do
    puts "Введіть число від 1 до 100:"
    guess = gets.chomp.to_i

    attempts += 1

    if guess < secret_number
      puts "Спробуйте більше число."
    elsif guess > secret_number
      puts "Спробуйте менше число."
    else
      puts "Вгадано!"
      puts "Кількість спроб: #{attempts}"
      break
    end
  end
end

play_game