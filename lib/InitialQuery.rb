require_relative '../environment'

class InitialQuery
    
    attr_accessor :limit, :category, :longitude, :latitude,
        :radius, :parsed_data, :open_boolean


    def initialize(latitude, longitude, radius, open_boolean)
        @limit = 50 
        # max limit the api supports as of 10/19/20 is 50
        @category = "Restaurants"
        @longitude = longitude
        @latitude = latitude
        @radius = radius
        @open_boolean = open_boolean
    end

    def query_to_hash
        url = "https://api.yelp.com/v3/businesses/search?limit=#{@limit}&category=#{@category}&latitude=#{@latitude}&longitude=#{@longitude}&radius=#{@radius}&open_now=#{@open_boolean}&price=1,2,3,4"
        raw_query_data = HTTP.auth("Bearer #{$APIKEY}").get(url)
        JSON.parse(raw_query_data)
    end

end

