require_relative '../lib/initial_query'


class Logic
    
    attr_accessor :longitude, :latitude, :radius, :query, :parsed_data

    def self.start
        self.new
        @parsed_data = @query.query_to_hash
        Restaurants.new_from_json(@parsed_data)
        

        
    end

    def initialize
        puts "Please enter longitude:"
        @longitude = gets.chomp

        puts "Please enter latitude:"
        @latitude = gets.chomp

        puts "enter radius (in miles) for search"
        @radius = (gets.chomp.to_f * 1609.34) 
        # This converts from miles, the standard unit of travel distance in the US, to meters, the unit that the Yelp API uses.
       
        @query = InitialQuery.new(@longitude, @latitude, @radius)
    end

end