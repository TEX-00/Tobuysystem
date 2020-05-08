class InviteController < ApplicationController
    before_action :logged_in_user , only: [:new,:temp_create]

    #一時ユーザー作成フォームの表示
    def new 
        @tempuser = Tmpuser.new
    end
    #一時ユーザーを作成しメール送信
    def create_temp

        user = User.where(email: get_email[:email])
        if user.length != 0
            render :plain => "アドレスはすでに使用されています"
            return
        end

        tmpusers = Tmpuser.where(email: get_email[:email])
        if tmpusers.length != 0
            tmpuser =  Tmpuser.where(email: get_email[:email]).first
            tmpuser.update(expire_at: 24.hours.since, uuid: SecureRandom.uuid)

        elsif
            Tmpuser.create(email: get_email[:email] , expire_at: 24.hours.since, uuid: SecureRandom.uuid)
        end

        tmpuser =  Tmpuser.where(email: get_email[:email]).first

        UserMailserMailer.welcome_email(tmpuser).deliver
        flash[:notice] = "完了"
        
        redirect_to "/" 
    end

    #本登録用フォームの表示
    def check_token
        tmpuser = Tmpuser.where(uuid: params[:uuid]).first

        if tmpuser.nil?
            render :plain => "そのようなトークンはありません"
            return
        elsif tmpuser.expire_at < Time.now
            render :plain => "期限切れのトークンです"
            tmpuser.destroy
            return
        end
        @user = User.new(email: tmpuser.email)
        @dest = "/auth/token/"+tmpuser.uuid
    end

    #本登録処理
    #トークンとメールアドレスが一時ユーザーと一致する必要あり
    #名前は一文字以上
    #パスワードは8文字以上、大文字-小文字-数字を含む必要あり
    def create_user
        uuid = params[:uuid]

        tmpuser = Tmpuser.where(uuid: uuid).where(email: get_user[:email]).first

        if tmpuser.nil?
            
            render :plain => "不正なアクセスです" , :status =>  404
            return
        end
        new_user = User.new(get_user)

        if get_user[:name].blank?

            render :plain => "空の名前です" , :status => 400
            return
        end

        if (get_user[:password] =~ /[a-z]/).nil?
            render :plain => "小文字が必要です" , :status => 400
            return
        end

        if (get_user[:password] =~ /[A-Z]/).nil?   
            render :plain => "大文字が必要です" , :status => 400
            return
        end

        if (get_user[:password] =~ /[0-9]/).nil?   
            render :plain => "数字が必要です" , :status => 400
            return
        end

        if get_user[:password].length < 9
            render :plain => "8文字以上必要です" , :status => 400
            return
        end

        if get_user[:password]!=get_user[:password_confirmation]
            render :plain => "確認用パスワードとパスワードが一致しませんでした" , :status => 400
            return
        end
        
        if new_user.save
            tmpuser.destroy
            render :plain => "登録完了しました" , :status => 200
            return
        end

        

        render :plain => "登録に失敗しました" , :status => 500
    end


    private
    def get_email
        params.require(:tmpuser).permit(:email)
    end


    def get_user
        params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end



end
