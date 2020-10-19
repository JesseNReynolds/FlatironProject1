# This class is responsible for formatting the initial query to the API
# and returning an array of businesses. It then creates an array of
# restaurant objects to be filtered and sampled.

require 'open-uri'
require 'net/http'
require 'json'

class InitialQuery
    attr_reader :limit, :category, :longitude, :latitude,
        :radius, :parsed_hash


    def initialize(longitude, latitude, radius)
        @limit = 50
        @category = "Restaurants"
        @longitude = longitude
        @latitude = latitude
        @radius = radius
    end

    def query_to_hash
        uri = "https://api.yelp.com/v3/businesses/search?limit=#{@limit}&category=#{@category}&latitude=#{@latitude}&longitude=#{@longitude}&radius=#{@radius}"
        raw_query_data = URI.parse(url)
        @parsed_hash = JSON.parse(raw_query_data)
    end

    def hash_to_objects


    end



end