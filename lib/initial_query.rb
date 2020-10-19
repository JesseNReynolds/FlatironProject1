class InitialQuery

"https://api.yelp.com/v3/businesses/search?limit=#{@limit}&category=#{@category}&location=#{@location}&radius=#{@radius}"

    def initialize(location,radius)
        @limit = 50
        @category = "Restaurants"
        @location = location
        @radius = radius
    end

end