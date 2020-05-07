class ToBuy < ApplicationRecord
    belongs_to :who_wants, class_name: "User"
    belongs_to :who_did, class_name: "User", optional: true

    def get_wants
        return @who_wants     
    end

    def get_date
        return @created_atcreated_at.strftime('%Y/%m/%d')
    end



    def attributes
        {
            "id" => nil,
            "name" => nil,
            "count" => nil,
            "special_option" => nil,
            "is_done" => nil,
            "created_at"=>nil,
            "updated_at"=>nil,
            "who_wants" =>nil,
            "who_did" => nil
        }

    end

end


