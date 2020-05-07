class UserMailserMailer < ApplicationMailer
    
    def welcome_email(tmpuser)
        @tmpuser = tmpuser
        @url = "https://servername/auth/token/"

        mail(to: @tmpuser.email, subject: "購入管理システムに招待されました")

    end

end
