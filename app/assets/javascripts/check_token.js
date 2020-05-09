const fap = new Vue({
    el: "#app",
    data: {
        name: "",
        //メールアドレスに初期値を与える

        password: "",
        password_confirmation: "",

    },
    methods: {
        //正しくない場合送信を拒否しアラートを表示する
        submit_fail: function() {
            alert("送信できません")
        }
    },
    computed: {
        //パスワードと確認用パスワードが等しいか確認する
        is_same: function() {
            return this.password === this.password_confirmation
        },
        //パスワードが正しいか確認する
        is_pw_ok: function() {
            if (this.password.length < 8)
                return false
            else if (!(/[a-z]/).test(this.password))
                return false
            else if (!(/[A-Z]/).test(this.password))
                return false
            else if (!(/[0-9]/).test(this.password))
                return false
            return true
        },
        //パスワードが正しくないときにその内容を入手する
        pw_error: function() {
            if (this.password.length < 8)
                return "8文字以上必要"
            else if (!(/[a-z]/).test(this.password))
                return "小文字が必要"
            else if (!(/[A-Z]/).test(this.password))
                return "大文字が必要"
            else if (!(/[0-9]/).test(this.password))
                return "数字が必要"
            return ""
        },
        //名前が正しいか取得する
        is_name_ok: function() {
            return this.name.length > 0
        },
        //すべての項目が正しいか確認する
        is_ok: function() {
            return this.is_name_ok && this.is_pw_ok && this.is_same
        }


    }



})
$(document).ready(function() {
    $("#user-create-form").on("ajax:success", function(event) {
        [data, status, xhr] = event.detail
        alert(xhr.responseText)
        window.location.href = '/login';



    }).on("ajax:error", function(event) {
        [data, status, xhr] = event.detail
        alert("登録失敗")

    })
})