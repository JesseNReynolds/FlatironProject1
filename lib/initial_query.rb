# This class is responsible for formatting the initial query to the API
# and returning an array of businesses. It then creates an array of
# restaurant objects to be filtered and sampled.


class InitialQuery



    def initialize(longitude, latitude, radius)
        @limit = 50
        @category = "Restaurants"
        @longitude = longitude
        @latitude = latitude
        @radius = radius
    end

    def query
        url = "https://api.yelp.com/v3/businesses/search?limit=#{@limit}&category=#{@category}&latitude=#{@latitude}&longitude=#{@longitude}&radius=#{@radius}"
        uri = URI.parse(url)

end