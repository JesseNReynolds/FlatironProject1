class InitialQuery

"https://api.yelp.com/v3/businesses/search?limit=#{@limit}&category=#{@category}&location=#{@location}&radius=#{@radius}"

def initialize(location,radius)
    @limit = 50
    @category = "Restaurants"
    @location = location
    @radius = radius
end

# def start
#     puts "enter zip code in which to search"
#    zip = gets.chomp
#    puts "enter radius (in miles) for search"
#    radius = (gets.chomp / 1609.34)
#    InitialQuery.new(zip, radius)
# end