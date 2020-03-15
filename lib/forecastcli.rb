module Weather
  class ForecastCli
    
    APP_ID = '1f792f9fe2181c904b1196d07a34cd8f'
    $prompt = TTY::Prompt.new 
    def start
        self.welcome
        self.instructions
    end

    def welcome
        puts 'Welcome to your forecast!'
        puts ''
        puts 'This is your personalized weather assistant that allows you
        to get daily weather information by zipcode.'
        line_break
        puts ''
        puts 'Instructions'
        puts ''
        puts 'Follow instruction bellow'
        puts 'Enter zipcode to get weather detail'
        puts "Type 'exit' to quit"
        self.line_break
        puts ''
    end

    def instructions
        puts 'Enter your five digit zipcode to get started or "exit" to quit:'
        zipcode = gets.chomp.downcase
        #check for vald zip code: all digits string and length = 5
        while zipcode != 'exit'
          if zipcode[/[0-9]+/] == zipcode && zipcode.length == 5
            system('cls') || system('clear')
            location = Weather::Forecast.new.location(zipcode)
            puts "This is the 24 HRS forecast for #{location}:"
            puts ''
            Weather::Forecast.new.hourly_forecast(zipcode)
            Weather::Forecast.new.day_display
            line_break
            puts ''
            @options = %w(Exit Check-Another-Area Next-Day-Forecast Next-2-Days-Forecast Next-3-Days-Forecast Next-4-Days-Forecast)
            additional_options
          else
            begin
              raise Error
            rescue Error => exception
              puts exception.message
            end
            instructions
          end
        end
        system('cls') || system('clear')
        goodbye
    end

    def additional_options
      menu
      system('cls') || system('clear')
      case @selection
      when 'Next-Day-Forecast' 
        @@counter = 1
        specific_request
        @options = %w(Exit Check-Another-Area Next-Day-Forecast Next-2-Days-Forecast Next-3-Days-Forecast)
        additional_options
        
      when 'Next-2-Days-Forecast'
        @@counter = 2
        specific_request
        @options = %w(Exit Check-Another-Area Next-Day-Forecast Next-2-Days-Forecast)
        additional_options
      when 'Next-3-Days-Forecast'
        @@counter = 3
        specific_request
        @options = %w(Exit Check-Another-Area Next-Day-Forecast)
        additional_options
      when 'Next-4-Days-Forecast'
        @counter = 4
        specific_request
        @options = %w(Exit Check-Another-Area)
        additional_options
      when 'Check-Another-Area'
        Weather::Forecast.erase
        system('cls') || system('clear')
        instructions

      else
        Weather::Forecast.erase
        system('cls') || system('clear')
          goodbye
          exit 
      end  

    end

    def menu
      @selection = $prompt.select("What would you like to do next?", @options)
    end

    def line_break
        puts '============================================================================================================='
    end

    def goodbye
      puts 'Thanks "for" visiting!'
      puts 'Enjoy the weather until next time :)'
    end

    def specific_request
      if Weather::Forecast.all.empty?
        begin
          raise WeatherError
        rescue WeatherError => exception
          puts exception.message
        end
        @options = %w(Exit Check-Another-Area)
        additional_options
      else  
        @@counter.times do
        Weather::Forecast.new.day_display unless Weather::Forecast.all.empty?
        end
      end
      line_break
    end

    class Error < StandardError
      def message
        puts 'Invalid Input'
        puts ''
        puts 'Please try again!'
      end
    end

    class WeatherError < StandardError
      def message
        puts 'No more Forecast available'
        puts ''
        puts 'Make another Selection!'
      end
    end
  
  end
  
  
end
