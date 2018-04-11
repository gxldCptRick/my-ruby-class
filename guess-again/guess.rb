$FILE_NAME = "notAVirus.txt"
continue = false
MAX_RANGE = 1000
$high_score_name = nil
$high_score = 100000
$game_is_over = nil
$guess_count = 0

class String
    def initial_character
        self[0,1]
    end

end

class HiScore
#scores organized like so [[score, name], [score,name]] 
    attr_accessor :scores
    
    def initialize
        :scores = []
        self.setup_score_board
    end

    def saveScores
        File.open($FILE_NAME, 'w') do |file|
        
            @scores.each do |score|
            
                file.puts "#{score[0]}, #{score[1]}"

            end

        end
    end

    def updateScores(newScore)
        
        if(@scores.length < 5)
            @scores.push(newScore)
            @scores.sort{|first, second| first[0] <=> second[0]};
        else
            @scores.each do |score|
                if(newScore[0] > score[0])
                    @scores.pop(@scores.index(score))
                    @scores.push(newScore)
                    @scores.sort {|first, second| first[0] <=> second[0] }
                    break
                end
            end
        end

    end

    def printScores
        puts "High Scores".center(10)
        puts "-" * 30
        @scores.each do |value| 
            puts "#{value[0]} - #{value[1]}" 
        end
    end

    def setup_score_board
        if(File.file?($FILE_NAME))
            File.open($FILE_NAME, 'r') do |file| 
                file.each_line do  |list|
                    values = line.split(",")
                    values[0] = values[0].to_i
                    @scores.push(values)
                end
            end
        end
    end
end

def refresh_high_score(current_score)
    if current_score < $high_score
        puts "You Have The New High score"
        puts "Enter your name."
        $high_score_name = gets.chomp
        $high_score = current_score
    else
        $high_score = $high_score
    end
end

def check_number(number_guessed)
    if (number_guessed.class == Integer && (number_guessed <= MAX_RANGE && number_guessed > 0))
            
        $guess_count += 1

        if (number_guessed > $number_to_guess)
            puts "You Guessed To High"
        elsif (number_guessed < $number_to_guess)
            puts "You Guessed To Low"
        else
            puts "You Win"
            $game_is_over = true
            refresh_high_score($guess_count)
        end
        
        puts  "Amount Of Guesses So far:  #{$guess_count}"
    
    else
        
        puts "Please input a number that is between 1 - #{MAX_RANGE}"

    end
end

begin
    $guess_count = 0
    $number_to_guess = rand(MAX_RANGE) + 1
    $game_is_over = false

    begin
        puts $number_to_guess
        puts "Enter A Number To Guess between 1 - #{MAX_RANGE}"
        userInput = gets.chomp
        number_guessed = userInput.to_i
        check_number(number_guessed)
    end while !$game_is_over

    puts "The Current High Score is #{$guess_count} number of guesses"
    puts "Would You Like To Continue? (type y to continue)"
    userInput = gets.chomp
    if(userInput.initial_character.upcase == 'Y')
        continue = true
        puts "Current Highscore: #{$high_score_name} - #{$high_score.to_s} guesses" 
    else
        continue = false
    end
    
end while continue