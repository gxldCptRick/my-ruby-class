require ('date')

class Holiday
    attr_accessor :holiday_name, :date
    def initialize(holiday_name, month, day, year)
        
        @holiday_name = holiday_name
        @date = Date.new(year,month,day)

    end


    def print_holiday()

        puts @date.strftime(@holiday_name + " is on %A, %B %d in %Y")

    end

end

class MovingHoliday < Holiday
    attr_accessor :day_of_week, :frequency, :month
    def initialize(holiday_name, day_of_week, frequency, month, year)
        super(holiday_name, month, 1, year)

        @day_of_week = day_of_week
        @frequency = frequency
        @month = month
        self.find_day
    
    end

    def find_day
        day_found = @date.month != @month || (@frequency == 0 && @date.cwday == @day_of_week)
        while !day_found
            @date = @date + 1;
            day_found = @date.month != @month
            
            if(!day_found && @date.cwday == @day_of_week)
                @frequency -= 1
                day_found = @frequency == 0
            end

        end

        if @date.month != @month
            raise 'Invalid Moving Holiday'
        end

    end 


end

class StaticHoliday < Holiday

    def initialize(holiday_name, month, day, year)
    
        super(holiday_name, month, day, year)
    
    end

end

def gather_user_input
    invalid_input = true
    input = nil
    begin
        print "Please Enter a Year: "
        input = gets.chomp;
        input = input.to_i
        invalid_input =  input < 1
        if(invalid_input)
            puts "Enter a number that is greater than 0"
        end
    end while invalid_input
    input
end

year = gather_user_input

new_years = StaticHoliday.new("New Years", 1, 1, year)
new_years.print_holiday

independence_day = StaticHoliday.new("Independence Day", 7, 4, year)
independence_day.print_holiday

halloween = StaticHoliday.new("Halloween", 10, 31, year)
halloween.print_holiday

mothers_day = MovingHoliday.new("Mother's Day", 7, 2, 5, year)
mothers_day.print_holiday

fathers_day = MovingHoliday.new("Father's Day", 7, 3, 6, year)
fathers_day.print_holiday

thanksgiving = MovingHoliday.new("Thanksgiving", 4, 4, 11, year)
thanksgiving.print_holiday