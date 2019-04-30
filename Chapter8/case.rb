def currency(country)
    case country
    when "Japan"
        puts "Yen"
    when "USA"
        puts "Dollar"
    when "China"
        puts "Yuan"
    end
end

def yes_no(answer)
    case answer
    when /[Yy]es/
        puts :yes
    when /[Nn]o/
        puts :no
    else
        nil
    end
end

currency("USA")

yes_no("Yes")

