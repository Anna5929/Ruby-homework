def word_stats(text)
  words = text.split

  word_count = words.length
  longest_word = words.max_by { |word| word.length }

  lowercase_words = words.map { |word| word.downcase }
  unique_words = lowercase_words.uniq
  unique_count = unique_words.length

  puts "Кількість слів: #{word_count}"
  puts "Найдовше слово: #{longest_word}"
  puts "Кількість унікальних слів: #{unique_count}"
end

puts "Введіть рядок тексту:"
text = gets.chomp

word_stats(text)
