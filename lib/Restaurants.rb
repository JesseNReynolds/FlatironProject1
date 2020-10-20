require_relative '../environment'

class Restaurants

    attr_accessor 

    @@all = []
    @@filtered_for_price = []
    @@filtered_for_rating = []
    @@filtered_by_types = []

    def self.filtered_by_types
        @@filtered_by_types
    end

    def self.filtered_for_price
        @@filtered_for_price
    end

    def self.filtered_for_rating
        @@filtered_for_rating
    end

    def self.all
        @@all
    end

    def save
        @@all << self
    end

    def self.new_from_json (parsed_data)
        parsed_data["businesses"].each do |hash|
            new_restaurant = Restaurants.new

            hash.each do |key, value|
                new_restaurant.class.send(:attr_accessor, "#{key}")
                # creates attr_accessor for each key in the imported hash  
                new_restaurant.send("#{key}=", value)
            end

            new_restaurant.save
        end
        
    end

    def self.price_range(array, min, max)
       array.each do |restaurant|
            if restaurant.price != nil && restaurant.price.length <= max && restaurant.price.length >= min
                @@filtered_for_price << restaurant
            end
        end
    end

    def self.rating_range(array, min, max)
        array.each do |restaurant|
            if restaurant.rating >= min && restaurant.rating <= max
                @@filtered_for_rating << restaurant
            end
        end  
    end

    def self.remove_by_types(array_of_restaurants, array_of_types)
        restaurants_to_exclude = []
        array_of_restaurants.each do |restaurant|
            restaurant.categories.each do |index_of_array|
                index_of_array.each do |key, value|
                    if key == "title" && array_of_types.include?(value)
                        restaurants_to_exclude << restaurant
                    end
                end
            end
        end
        @@filtered_by_types = array_of_restaurants - restaurants_to_exclude 
        binding.pry
    end
    # NOT SURE IF THIS WORKS YET :UPSIDE_DOWN_FACE:

end
    