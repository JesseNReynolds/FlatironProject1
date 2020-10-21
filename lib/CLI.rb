require_relative '../environment'


class CLI
    
    attr_accessor :query, :parsed_data

    def start
        self.send_and_parse
        self.filter_rating
        self.filter_price
        self.exclude_types
        self.print_random_restaurant
        self.ask_about_reviews
    end

    def initialize

        puts "Please enter latitude:"
        latitude = gets.chomp


        puts "Please enter longitude:"
        longitude = gets.chomp


        puts "Please enter radius (in miles) for search"
        radius = (gets.chomp.to_f * 1609.34).to_i 
        # This converts from miles, the standard unit of travel distance in the US, to meters, the unit that the Yelp API uses.
        
        @query = InitialQuery.new(latitude, longitude, radius)
        # @query = InitialQuery.new(-105, 40, 10000)
    end

    def send_and_parse
        @parsed_data = @query.query_to_hash
        Restaurants.new_from_json(@parsed_data)
    end

    def filter_rating
        puts "Do you want to filter by rating? (y/n)"
        answer = gets.chomp
        if answer == "y"
            puts "Please enter minimum permissible rating from 1-5 (decimals OK!)"
            min_rating = gets.chomp.to_f

            puts "Please enter maximum permissible rating from 1-5 (decimals OK!)"
            max_rating = gets.chomp.to_f
        elsif answer == "n"
            min_rating = 1
            max_rating = 2
        else
            puts "Sorry, I don't understand, please respond with y or n"
            filter_price
        end

        Restaurants.rating_range(Restaurants.all, min_rating, max_rating)
        #  Restaurants.rating_range(Restaurants.all, 1, 5)
    end

    def filter_price
        puts "Do you want to filter by price? (y/n)"
        answer = gets.chomp
        if answer == "y"
            puts "Restaurants are given price ranges from 1 to 4, where 4 is the highest."
            
            puts "Please enter a minimum price range from 1 to 4 (decimals NOT OK!)"
            min_price = gets.chomp.to_i

            puts "Please enter a maximum price range from 1 to 4(decimals NOT OK!)"
        max_price = gets.chomp.to_i
        elsif answer == "n"
            min_price = 1
            max_price = 4
        else
            puts "Sorry, I don't understand, please respond with y or n"
            filter_price
        end

        Restaurants.price_range(Restaurants.filtered_for_rating, min_price, max_price)
        # Restaurants.price_range(Restaurants.filtered_for_rating, 1, 4)
    end  

    def exclude_types
        array_of_titles = []
        
        Restaurants.filtered_for_price.each do |restaurant|
            restaurant.categories.each do |index_of_array|
                index_of_array.each do |key, value|
                    if key == "title" && !array_of_titles.include?(value)
                        array_of_titles << value
                    end
                end
            end
        end

        puts "Ommit types by entering any undesired entry numbers (ex: 1, 3, 10 or 1,3,10)"
        array_of_titles.each_with_index do |value, index|
            puts "#{index + 1}: #{value}"
        end
        to_ommit = gets.chomp.gsub(/\s+/, "").split(",")
        
        to_ommit.each_with_index do |value, index|
            to_ommit[index.to_i] = array_of_titles[value.to_i - 1]
        end
        # this transforms to_ommit from an array of ints to an array of titles.

        Restaurants.remove_by_types(Restaurants.filtered_for_price, to_ommit)
    end

    def print_random_restaurant
        @chosen_one = Restaurants.filtered_by_types.sample
        puts "Y'all gonna eat at #{@chosen_one.name}. Get in the car."
        puts "#{@chosen_one.location["display_address"]}"
        puts "Price range: #{@chosen_one.price}/$$$$"
        puts "Rated #{@chosen_one.rating} in #{@chosen_one.review_count} reviews."
        # I think the above line is against the spirit of the the app
        # which is light-hearted discovery, but I'm leaving it for now.
    end

    def ask_about_reviews
        puts "Would you like to see three review excerpts? (y/n)"
        answer = gets.chomp
        if answer == "y"
            puts "#{@chosen_one.parsed_reviews["reviews"][0]["text"]}"
            puts "#{@chosen_one.parsed_reviews["reviews"][1]["text"]}"
            puts "#{@chosen_one.parsed_reviews["reviews"][2]["text"]}"
        elsif answer == "n"
            puts "Good, get in the car."
        end
    end
  
end