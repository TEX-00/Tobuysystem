class ToBuyController < ApplicationController
    before_action :logged_in_user
    #一覧表示の枠組みを渡す
    def index
    end

    #削除機能、最終更新時間と依頼者が一致する必要あり
    def delete

        id = will_be_deleted[:id]

        upd = will_be_deleted[:updated_at]
        begin
            target = ToBuy.find_by_id(id)
        rescue
            render plain: "NoEntry"
            return
        end

        if Time.zone.parse(upd).to_s != target.updated_at.to_s
            render plain: "Your request is not lastest #{Time.zone.parse(upd)} != #{target.updated_at}"
            return
        elsif current_user != target.who_wants
            render plain: "This entry is noe your entry"
            return

        end

        ToBuy.destroy(target.id)

        render plain: "OK deleted"
        return
    end

    #購入済みかどうかを変更する機能
    #購入済みを未購入に戻すのは購入者のみの権利
    def change_done
        id = change_params[:id]
        done = change_params[:done]

        begin
            target = ToBuy.find_by_id(id)
        rescue
            render plain: "NoEntry" 
            return
        end

        if target.is_done == done
            render plain: "Conflicts"           
            return
        end

        if target.is_done == false
            ToBuy.update(id,is_done: true,who_did: current_user)
            render plain:"Ok Changed"           
            return
        elsif target.who_did == current_user
            ToBuy.update(id,is_done: false,who_did: nil)
            render plain:"Ok Changed"                    
            return
        else
            render plain:"You cant change" 
            return
        end
    end

    #一覧をjsonで渡す
    def list_api
        temp = ToBuy.all
        render :json => {"tobuys":temp}
    end
    
    #新規作成機能
    def new
        @newtobuy = ToBuy.new
    end

    #新規作成機能
    def create
        @newtobuy = initTobuy
        if @newtobuy.save!
            render plain: "OK Created"
        else
            render "create"
        end
    end

    private
    def post_params
     params.require(:to_buy).permit(:name,:count,:special_option)
    end
    def change_params
        params.require(:id_done).permit(:id,:done)
    end

    def will_be_deleted
        params.require(:to_buy).permit(:id,:name,:updated_at)
    end


    def initTobuy
        return ToBuy.new(
            name: post_params[:name],
            count: post_params[:count],
            special_option: post_params[:special_option],
            is_done: false,
            who_wants: current_user,
            who_did: nil

        )
    end

end
