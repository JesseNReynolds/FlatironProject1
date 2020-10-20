require_relative '../lib/initial_query'
require_relative '../environment'


class CLI
    
    attr_accessor :query, :parsed_data

    def start
        self.send_and_parse
        self.filter_rating
        self.filter_price
        
    end

    def initialize

        puts "Please enter longitude:"
        longitude = gets.chomp

        puts "Please enter latitude:"
        latitude = gets.chomp

        puts "Please enter radius (in miles) for search"
        radius = (gets.chomp.to_f * 1609.34).to_i 
        # This converts from miles, the standard unit of travel distance in the US, to meters, the unit that the Yelp API uses.
        
        @query = InitialQuery.new(longitude, latitude, radius)
    end

    def send_and_parse
        @parsed_data = @query.query_to_hash
        Restaurants.new_from_json(@parsed_data)      
    end

    def filter_rating
        puts "Please enter minimum permissible rating from 1-5 (decimals OK!)"
        min_rating = gets.chomp.to_f

        puts "Please enter maximum permissible rating from 1-5 (decimals OK!)"
        max_rating = gets.chomp.to_f

        Restaurants.rating_range(Restaurants.all, min_rating, max_rating)
    end

    def filter_price
        puts "Restaurants are given price ranges from 1 to 4, where 4 is the highest."
        
        puts "Please enter a minimum price range from 1 to 4 (decimals NOT OK!)"
        min_price = gets.chomp.to_i

        puts "Please enter a maximum price range from 1 to 4(decimals NOT OK!)"
        max_price = gets.chomp.to_i

        Restaurants.price_range(Restaurants.filtered_for_rating, min_price, max_price)
    end

        


end