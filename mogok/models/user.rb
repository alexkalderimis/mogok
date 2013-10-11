require "rubygems"
require "bcrypt"

class User

    include BCrypt
    include DataMapper::Resource
    include Mogok::Model

    property :username, String, :length => 255, :unique => true, :index => true
    property :passhash, String, :length => 255

    def password
        @password ||= Password.new(passhash)
    end

    def password=(new_password)
        @password = Password.create(new_password, :cost => 10)
        self.passhash = @password
    end

end
