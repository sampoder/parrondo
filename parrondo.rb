class Game
  def initialize(game, epsilon, plays)
    @game = game
    @epsilon = epsilon
    @plays = plays
    @fortune = 0
  end

  def flip_coin(success)
    rand <= success
  end

  def a
    flip_coin(0.5 - @epsilon) ? 1 : -1
  end

  def b
    coin = if @fortune % 3 == 0
             0.1 - @epsilon
           else
             0.75 - @epsilon
           end
    flip_coin(coin) ? 1 : -1
  end

  def combined
    flip_coin(0.5) ? a : b
  end

  def play
    for x in 1..@plays
      case @game
      when :combined
        @fortune += combined
      when :a
        @fortune += a
      when :b
        @fortune += b
      end
    end
    @fortune
  end
end

class Test
  def initialize(game, epsilon, games, plays)
    @game = game
    @epsilon = epsilon
    @plays = plays
    @games = games
    @results = []
  end

  def test
    for x in 1..@games
      @results.push(
        Game.new(@game, @epsilon, @plays).play
      )
    end
  end

  def to_s
    mean = @results.reduce(:+).to_f / @results.length

    sorted_results = @results.sort
    mid = sorted_results.length / 2
    median = if sorted_results.length.odd?
               sorted_results[mid]
             else
               (
                             sorted_results[mid - 1] +
                             sorted_results[mid]
                           ) / 2.0
             end

    max = @results.max
    min = @results.min

    wins = @results.count { |result| result > 0 }

    "
    Mean Score: #{mean}
    Median Score: #{median}
    Max Score: #{max}
    Min Score: #{min}
    Wins: #{wins}/#{@games}
    "
  end
end

puts "Parrondo's Paradox: The Coin Flip \n \n"

puts "Testing Game A:"
a = Test.new(:a, 0.005, 10, 1_000_000)
a.test
puts a

puts "Testing Game B:"
b = Test.new(:b, 0.005, 10, 1_000_000)
b.test
puts b

puts "Testing Combined Game:"
combined = Test.new(:combined, 0.005, 10, 1_000_000)
combined.test
puts combined

puts "github.com/sampoder/parrondo"
