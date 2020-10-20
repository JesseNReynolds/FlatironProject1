require_relative '../environment'

class Restaurants

    attr_accessor 

    @@all = []
    @@filtered_for_price = []
    @@filtered_for_rating = []


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
                # if key == ("rating" || "price" || "phone" || "id" || "name" || "address1" || "address2" || "city" || "zip_code" || "address3" || "transactions")
                new_restaurant.class.send(:attr_accessor, "#{key}")
                # creates attr_accessor for each key in the imported hash  
                new_restaurant.send("#{key}=", value)
                # end
            end

            new_restaurant.save
        end
        
    end

    def self.price_range(array, min, max)
       array.each do |restaurant|
        binding.pry
            if restaurant.price.length <= max && restaurant.price.length >= min
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


end
    