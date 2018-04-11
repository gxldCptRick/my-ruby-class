$FILE_NAME = "notAVirus.txt"
$SCORE_INDEX = 0
$NAME_INDEX = 1

class String
  def initial_character
    self[0, 1]
  end
end

class HiScore
  #scores organized like so [[score, name], [score,name]]
  attr_accessor :scores

  def initialize
    @scores = []
    initialize_board
  end

  def save_scores
    File.open($FILE_NAME, "w") do |file|
      @scores.each do |score|
        file.puts "#{score[$SCORE_INDEX]}, #{score[$NAME_INDEX]}"
      end
    end
  end

  def update_scores(new_score)
    if (@scores.length < 5)
      @scores.push(new_score)
    else
      @scores.each do |score|
        p score
        p new_score
        if (new_score[$SCORE_INDEX] < score[$SCORE_INDEX])
          index = @scores.index(score)
          @scores[index] = new_score
          break
        end
      end
    end

    @scores.sort! { |first, second| first[$SCORE_INDEX] <=> second[$SCORE_INDEX] }
  end

  def print_scores
    puts "High Scores".center(10)
    puts "-" * 30
    @scores.each do |value|
      puts "#{value[$SCORE_INDEX]} - #{value[$NAME_INDEX]}"
    end
  end

  def is_full?
    @scores.length > 4
  end

  def get_lowest_score
    last_index = @scores.length - 1
    @scores[last_index]
  end

  private

  def initialize_board
    if (File.file?($FILE_NAME))
      File.open($FILE_NAME, "r") do |file|
        file.each_line do |line|
          values = line.split(",")
          values[$SCORE_INDEX] = values[$SCORE_INDEX].to_i
          values[$NAME_INDEX].strip!
          @scores.push(values)
        end
      end
    end
  end
end

class NumberGuessingGame
  def initialize
    @continue = false
    @MAX_RANGE = 1000
    @high_score = [10000000, "milo da great"]
    @score_board = HiScore.new
    @game_is_over = nil
    @current_guess_count = 0
    @number_to_guess = 0
  end

  def start_game
    begin
      @current_guess_count = 0
      @number_to_guess = rand(@MAX_RANGE) + 1
      @game_is_over = false

      begin
        puts @number_to_guess
        puts "Enter A Number To Guess between 1 - #{@MAX_RANGE}"
        userInput = gets.chomp
        number_guessed = userInput.to_i
        check_number(number_guessed)
      end while !@game_is_over

      puts "The Score to beat is #{@high_score[$SCORE_INDEX]} number of guesses held by #{@high_score[$NAME_INDEX]}"
      puts "Would You Like To Continue? (type y to continue)"
      userInput = gets.chomp

      if (userInput.initial_character.upcase == "Y")
        @continue = true
        @score_board.print_scores
      else
        @continue = false
        @score_board.save_scores
      end
    end while @continue
  end

  private

  def check_number(number_guessed)
    if (!(number_guessed.class == Integer))
      number_guessed = number_guessed.to_i
    end
    if (number_guessed <= @MAX_RANGE && number_guessed > 0)
      @current_guess_count += 1

      if (number_guessed > @number_to_guess)
        puts "You Guessed To High"
      elsif (number_guessed < @number_to_guess)
        puts "You Guessed To Low"
      else
        puts "You Win"
        @game_is_over = true
        refresh_high_score(@current_guess_count)
      end

      puts "Amount Of Guesses So far:  #{@current_guess_count}"
    else
      puts "Please input a number that is between 1 - #{@MAX_RANGE}"
    end
  end

  def refresh_high_score(current_score)
    if (current_score < @high_score[$SCORE_INDEX] || !@score_board.is_full?)
      puts "You Have The New High score"
      puts "Enter your name."
      user_name = gets.chomp
      user_name.strip!
      new_score = [current_score, user_name]
      @score_board.update_scores(new_score)
      lowest_score_on_board = @score_board.get_lowest_score
      @high_score.replace(lowest_score_on_board)
    end
  end
end

game = NumberGuessingGame.new

game.start_game
