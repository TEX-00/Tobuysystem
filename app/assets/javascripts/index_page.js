Vue.config.devtools = true;
var tblapp = new Vue({
    el: '#app',
    data: {
        //依頼オブジェクトを格納する配列
        tobuys: [],
        //モーダル表示対象id,nullの時は表示しない
        detail_id: null,
        //購入済みの物を表示するフラグ
        bought: true,
        //未購入の物を表示するフラグ
        unbought: true,
        //自分の依頼のみ表示するするフラグ
        only_yours: false,
        //依頼者で絞り込む文字列
        user: "",
        //自分の購入のみ表示するフラグ
        your_bought: false,
        //購入者で絞り込むフラグ
        bought_user: "",
        //並べ替えルール集
        sort_rules: {
            name: (a, b) => a.name < b.name ? 1 : -1,
            name_rev: (a, b) => a.name < b.name ? -1 : 1,
            bought: (a, b) => a.is_done == true && b.is_done == false ? -1 : 1,
            bought_rev: (a, b) => a.is_done == false && b.is_done == true ? -1 : 1,
            user: (a, b) => a.who_wants.name < b.who_wants.name ? 1 : -1,
            user_rev: (a, b) => a.who_wants.name < b.who_wants.name ? -1 : 1,
            date: (a, b) => a.created_at > b.created_at ? 1 : -1,
            date_rev: (a, b) => a.created_at < b.created_at ? -1 : 1,
        },
        //並べ替え初期値
        sort_rule: (a, b) => a.name < b.name ? 1 : -1,
        //並べ替えルール名
        rule_name: ""
    },




    methods: {
        //リストを取得する
        load_list: function() {
            axios.get("list_api")
                .then(response => {
                    this.tobuys = response.data.tobuys;

                })
        },
        //現在の並べ替えルールを変更する
        rule_change: function(name) {
            this.sort_rule = this.sort_rules[name]
            this.rule_name = name
        },
        //購入済みフラグを変更するリクエストを送る
        change_done: function(id) {
            this.is_safe = false;
            var targetid = this.tobuys.findIndex((it) => it.id == id)
            var target = this.tobuys[targetid]
            var is_done = target.is_done
            axios.defaults.headers['X-CSRF-TOKEN'] = $('meta[name=csrf-token]').attr('content')
            axios({
                url: "change",
                method: "POST",
                data: {
                    id_done: {
                        id: id,
                        done: !is_done,
                    }
                }
            }).then(response => {

            })

            this.load_list()
            this.is_safe = true;
            this.$forceUpdate();
        },
        //削除リクエストを送信する
        send_delete: function(id) {
            var targetid = this.tobuys.findIndex((it) => it.id == id)
            var target = this.tobuys[targetid]

            axios.defaults.headers['X-CSRF-TOKEN'] = $('meta[name=csrf-token]').attr('content')
            axios({
                url: "delete",
                method: "POST",
                data: {
                    to_buy: target
                }
            }).then(response => {
                alert(response.data)
            })
            this.load_list()
            this.detail_id = null
        },
        //モーダルのボタンから購入済みフラグを変更するリクエストを送る
        change_from_modal: function(id) {
            this.change_done(id);
            this.openmdw(id)


        },
        //モーダルを開く
        openmdw: function(id) {
            this.detail_id = id
        }
    },
    //初期ダウンロード
    mounted: function() {
        this.load_list()
    },
    computed: {
        //詳細表示するオブジェクト
        detailed: function() {
            id = this.tobuys.findIndex((it) => it.id == this.detail_id)
            return this.tobuys[id]
        },
        //フィルタリングと並び替えされた配列
        filtered: function() {
            var result = this.tobuys

            if (this.bought === false) {
                result = result.filter(it => it.is_done === false)
            }
            if (this.unbought === false) {
                result = result.filter(it => it.is_done === true)
            }

            if (this.only_yours) {
                result = result.filter(it => it.who_wants.id === your_id)
            }

            result = result.filter(it => it.who_wants.name.includes(this.user))

            if (this.your_bought) {
                result = result.filter(it => (it.who_did != null) && (it.who_did.id === your_id))
            }
            if (this.bought_user != "") {
                result = result.filter(it => (it.who_did != null) && (it.who_did.name.includes(this.bought_user)))
            }

            result.sort(this.sort_rule)
            return result
        }
    }
});