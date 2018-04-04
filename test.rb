class User
    attr_accessor :name, :address, :password

    def initialize(name, address, password)
        @name = name
        @address = address
        @password = password
    end
    
end

milo = User.new("milo", "milo@milo.org", "xXxMiloxXx")

p milo
