require_relative initial_query.rb
require_relative '../environment'

class Filter

    # refactor to Restaurants class methods

    attr_accessor :price_min, :price_max, :rating_min, :rating_max

    def price_range(min, max)
        working = []
        restaurants.all.each do |restaruant|
            if restaruant.price.length <= @price_max && restaurant.price.length >= @price_min
               working << restaurant
            end
        end
        return working
    end

    def rating_range(min, max)

    end






end
