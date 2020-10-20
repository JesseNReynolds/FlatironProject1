require_relative '../environment'

class InitialQuery
    
    attr_accessor :limit, :category, :longitude, :latitude,
        :radius, :parsed_data


    def initialize(longitude, latitude, radius)
        @limit = 50 
        # max limit the api supports as of 10/19/20 is 50
        @category = "Restaurants"
        @longitude = longitude
        @latitude = latitude
        @radius = radius
    end

    def query_to_hash
        url = "https://api.yelp.com/v3/businesses/search?limit=#{@limit}&category=#{@category}&latitude=#{@latitude}&longitude=#{@longitude}&radius=#{@radius}"
        raw_query_data = HTTP.auth("Bearer #{$APIKEY}").get(url)
        @parsed_data = JSON.parse(raw_query_data)   
    end

end

