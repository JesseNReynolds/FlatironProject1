require_relative '../lib/initial_query'


class Logic
    attr_accessor :longitude, :latitude, :radius, :query

    def start
        initial_inputs



    end

    def initial_inputs
        puts "Please enter longitude:"
        @longitude = gets.chomp

        puts "Please enter latitude:"
        @latitude = gets.chomp

        puts "enter radius (in miles) for search"
        @radius = (gets.chomp * 1609.34) 
        # This converts from miles, the standard unit of travel distance in the US, to meters, the unit that the Yelp API uses.
       
        @query = InitialQuery.new(@longitude, @latitude, @radius)
    end

end