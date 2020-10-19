class Logic

    def start
        puts "enter zip code in which to search"
        zip = gets.chomp
        puts "enter radius (in miles) for search"
        radius = (gets.chomp / 1609.34)
        InitialQuery.new(zip, radius)
    end

end