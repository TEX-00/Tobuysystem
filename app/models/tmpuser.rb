class Tmpuser < ApplicationRecord

    def is_expired
        return Time.now < @expire_at
    end

end
