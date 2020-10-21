require_relative '../environment'


class CLI
    
    attr_accessor :query, :parsed_data, :latitude, :longitude, :radius, :open_boolean

    def start
        self.location_info
        self.open_now
        self.send_and_parse
        self.check_empty(Restaurants.all)
        self.filter_rating
        self.check_empty(Restaurants.filtered_for_rating)
        self.filter_price
        self.check_empty(Restaurants.filtered_for_price)
        self.exclude_types
        self.check_empty(Restaurants.filtered_by_types)
        self.filter_by_transactions
        self.check_empty(Restaurants.filtered_by_transactions)
        self.print_random_restaurant
        self.ask_about_reviews
    end

    def location_info

        puts "Please enter latitude:"
        @latitude = gets.chomp


        puts "Please enter longitude:"
        @longitude = gets.chomp


        puts "Please enter radius (in miles) for search"
        @radius = (gets.chomp.to_f * 1609.34).to_i 
        # This converts from miles, the standard unit of travel distance in the US, to meters, the unit that the Yelp API uses.
    end

    def open_now
        puts "Would you like to return restaurants that are closed right now? (y/n)"
        open_only = gets.chomp
            if open_only == "y" ||  open_only.downcase == "yes"
                @open_boolean = true
            elsif open_only == "n" || open_only.downcase == "no"
                @open_boolean = false
            else
                puts "Sorry, I don't understand, please respond with y or n"
                open_now
            end 
        end

    def send_and_parse
        @query = InitialQuery.new(@latitude, @longitude, @radius, @open_boolean)
        @parsed_data = @query.query_to_hash
        Restaurants.new_from_json(@parsed_data)
    end

    def check_empty(list)
        if list == []
            puts "Sorry, we couldn't find any restaurants that meet your criteria, please start again!"
            puts "Collecting info again in 5..."
            sleep 1
            puts "Collecting info again in 4..."
            sleep 1
            puts "Collecting info again in 3..."
            sleep 1
            puts "Collecting info again in 2..."
            sleep 1
            puts "Collecting info again in 1..."
            sleep 1
            self.start            
        end
    end
    
    def filter_rating
        puts "Do you want to filter by rating? (y/n)"
        answer = gets.chomp
        if answer == "y" || answer.downcase == "yes"
            puts "Please enter minimum permissible rating from 1-5 (decimals OK!)"
            min_rating = gets.chomp.to_f

            puts "Please enter maximum permissible rating from 1-5 (decimals OK!)"
            max_rating = gets.chomp.to_f
        elsif answer == "n" || answer.downcase == "no"
            min_rating = 1
            max_rating = 5
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
        if answer == "y" || answer.downcase == "yes"
            puts "Restaurants are given price ranges from 1 to 4, where 4 is the highest."
            
            puts "Please enter a minimum price range from 1 to 4 (decimals NOT OK!)"
            min_price = gets.chomp.to_i

            puts "Please enter a maximum price range from 1 to 4(decimals NOT OK!)"
        max_price = gets.chomp.to_i
        elsif answer == "n" || answer.downcase == "no"
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
            restaurant.categories.each do |category|
                category.each do |key, value|
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

    def filter_by_transactions
        puts "Would you like to see all restaurants, or only ones that offer delivery?"
        puts "1: All"
        puts "2: Delivery only"
        answer = gets.chomp

        if answer.to_i == 1 || answer.downcase == "all"
            filter_boolean = false
        elsif answer.to_i == 2 || answer.downcase == "delivery" || answer.downcase == "delivery only"
            filter_boolean = true
        else
            puts "I'm sorry, I don't understand. Please enter 1 or 2."
            filter_by_transactions
        end

        Restaurants.filter_for_delivery(Restaurants.filtered_by_types, filter_boolean)
    end
    



  
    
    def print_random_restaurant
        @chosen_one = Restaurants.filtered_by_transactions.sample
        puts "Y'all gonna eat at #{@chosen_one.name}. Enjoy your meal!"
        puts "#{@chosen_one.location["display_address"]}"
        puts "Price range: #{@chosen_one.price}/$$$$"
        puts "Rated #{@chosen_one.rating} in #{@chosen_one.review_count} reviews."
        # I think the above line is against the spirit of the the app
        # which is light-hearted discovery, but I'm leaving it for now.
    end

    def ask_about_reviews
        puts "Would you like to see three review excerpts? (y/n)"
        answer = gets.chomp
        if answer == "y" || answer.downcase == "yes"
            @chosen_one.reviews
            puts "=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--="
            puts "#{@chosen_one.parsed_reviews["reviews"][0]["user"]["name"]} gave this restaurant #{@chosen_one.parsed_reviews["reviews"][0]["rating"]} stars."
            puts "#{@chosen_one.parsed_reviews["reviews"][0]["text"]}"
            puts "=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--="
            puts "#{@chosen_one.parsed_reviews["reviews"][1]["user"]["name"]} gave this restaurant #{@chosen_one.parsed_reviews["reviews"][1]["rating"]} stars."
            puts "#{@chosen_one.parsed_reviews["reviews"][1]["text"]}"
            puts "=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--=--="
            puts "#{@chosen_one.parsed_reviews["reviews"][2]["user"]["name"]} gave this restaurant #{@chosen_one.parsed_reviews["reviews"][2]["rating"]} stars."
            puts "#{@chosen_one.parsed_reviews["reviews"][2]["text"]}"
        elsif answer == "n" || answer.downcase == "no"
            puts "Enjoy your meal!"
        else
            puts "Sorry, I don't understand, please respond with y or n"
            ask_about_reviews
        end
    end
  
end