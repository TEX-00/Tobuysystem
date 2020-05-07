class User < ApplicationRecord
    has_secure_password

    has_many :to_buys, dependent: :destroy


    def attributes
        {
            "id" => nil,
            "name" => nil,
        }

    end

end
