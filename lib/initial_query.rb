# This class is responsible for formatting the initial query to the API
# and returning an array of businesses. It then creates an array of
# restaurant objects to be filtered and sampled.

require 'open-uri'
require 'net/http'
require 'json'

    # {
    #   "rating": 4,
    #   "price": "$",
    #   "phone": "+14152520800",
    #   "id": "E8RJkjfdcwgtyoPMjQ_Olg",
    #   "alias": "four-barrel-coffee-san-francisco",
    #   "is_closed": false,
    #   "categories": [
    #     {
    #       "alias": "coffee",
    #       "title": "Coffee & Tea"
    #     }
    #   ],
    #   "review_count": 1738,
    #   "name": "Four Barrel Coffee",
    #   "url": "https://www.yelp.com/biz/four-barrel-coffee-san-francisco",
    #   "coordinates": {
    #     "latitude": 37.7670169511878,
    #     "longitude": -122.42184275
    #   },
    #   "image_url": "http://s3-media2.fl.yelpcdn.com/bphoto/MmgtASP3l_t4tPCL1iAsCg/o.jpg",
    #   "location": {
    #     "city": "San Francisco",
    #     "country": "US",
    #     "address2": "",
    #     "address3": "",
    #     "state": "CA",
    #     "address1": "375 Valencia St",
    #     "zip_code": "94103"
    #   },

class InitialQuery
    
    attr_accessor :limit, :category, :longitude, :latitude,
        :radius, :parsed_data,


    def initialize(longitude, latitude, radius)
        @limit = 50 
        # max limit the api supports as of 10/19/20 is 50
        @category = "Restaurants"
        @longitude = longitude
        @latitude = latitude
        @radius = radius
    end

    def query_to_hash
        uri = "https://api.yelp.com/v3/businesses/search?limit=#{@limit}&category=#{@category}&latitude=#{@latitude}&longitude=#{@longitude}&radius=#{@radius}"
        raw_query_data = URI.parse(url)
        @parsed_data = JSON.parse(raw_query_data)
    end

end

class Restaurants

    attr_accessor :rating, :price, :phone, :id, :name, :transactions,
     :address1, :address2, :address3, :city, :zip_code

    @@all = []

    def self.all
        @@all
    end

    def save
        @@all << self
    end

    def new_from_json (parsed_data)
        parsed_data["businesses"].each do |hash|
            new_restaurant = Restaurants.new

            hash.each do |key, value|
                if key == ("rating" || "price" || "phone" || "id" || "name" || "address1" || "address2" || "city" || "zip_code" || "address3" || "transactions")
                    new_restaurant.send("#{key}=", value)
                end
            end

            new_restaurant.save
        end
        
    end

end
    