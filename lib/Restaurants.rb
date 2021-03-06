require_relative '../environment'

class Restaurants

    attr_accessor :parsed_reviews

    @@all = []
    @@filtered_for_price = []
    @@filtered_for_rating = []
    @@filtered_by_types = []
    @@filtered_by_transactions = []

    def parsed_reviews
        @parsed_reviews
    end

    def self.filtered_by_types
        @@filtered_by_types
    end

    def self.filtered_for_price
        @@filtered_for_price
    end

    def self.filtered_for_rating
        @@filtered_for_rating
    end

    def self.filtered_by_transactions
        @@filtered_by_transactions
    end


    def self.all
        @@all
    end

    def save
        @@all << self
    end

    def self.new_from_json(parsed_data)
        parsed_data["businesses"].each do |business|
            new_restaurant = Restaurants.new

            business.each do |key, value|
                new_restaurant.class.send(:attr_accessor, "#{key}")
                # creates attr_accessor for each key in the imported hash  
                new_restaurant.send("#{key}=", value)
            end

            new_restaurant.save
        end
    end

    def self.rating_range(array, min, max)
        @@filtered_for_rating = array.select do |restaurant|
            restaurant.rating >= min && restaurant.rating <= max
        end  
    end

    def self.price_range(array, min, max)
       @@filtered_for_price = array.select do |restaurant|
            restaurant.price.length <= max && restaurant.price.length >= min
        end
    end

    def self.remove_by_types(array_of_restaurants, array_of_types)
        restaurants_to_exclude = []
        array_of_restaurants.each do |restaurant|
            restaurant.categories.each do |type|
                type.each do |key, value|
                    if key == "title" && array_of_types.include?(value)
                        restaurants_to_exclude << restaurant
                    end
                end
            end
        end
        @@filtered_by_types = array_of_restaurants - restaurants_to_exclude 
    end

    def self.filter_for_delivery(array_of_restaurants, filter_boolean)
        if filter_boolean == true

            @@filtered_by_transactions = array_of_restaurants.select do |restaurant|
                restaurant.transactions.include?("delivery")
            end


        else 
            array_of_restaurants.each do |restaurant|
            @@filtered_by_transactions << restaurant
            end
        end
    end


    def reviews
        url = "https://api.yelp.com/v3/businesses/#{self.id}/reviews"
        raw_query_data = HTTP.auth("Bearer #{$APIKEY}").get(url)
        @parsed_reviews = JSON.parse(raw_query_data)
    end


end
    