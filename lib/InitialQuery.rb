require_relative '../environment'

# This class is responsible for formatting the initial query to the API
# and returning an array of businesses. It then creates an array of
# restaurant objects to be filtered and sampled.


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

