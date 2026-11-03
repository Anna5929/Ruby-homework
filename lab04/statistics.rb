class Statistics
  attr_reader :wins, :losses

  def initialize
    @wins = 0
    @losses = 0
  end

  def record_result(result)
    case result
    when :win
      @wins += 1
    when :loss
      @losses += 1
    end
  end

  def total_games
    @wins + @losses
  end

  def display
    puts "\n=== СТАТИСТИКА ІГОР ==="
    puts "Зіграно ігор: #{total_games}"
    puts "Перемог: #{@wins}"
    puts "Поразок: #{@losses}"
  end
end
