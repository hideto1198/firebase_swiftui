import Foundation
import Firebase
import FirebaseInstanceID
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging


class firebase_test: ObservableObject{
    @Published var isAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var title: String = ""
    @Published var message: String = ""
    
    let db = Firestore.firestore()
    var functions = Functions.functions()
    
    func http_connect(){
        // 初期化
        self.isAlert = false
        // 通信中のメッセージ or view　を出すためにisLoadingをtrueにしておく
        self.isLoading = true
        //返り値を格納する変数 JSONをNSDictionary型に変換する
        var datas:NSDictionary = NSDictionary()
        //注意 keyに"data"がないとCloud functionsでデータの受け取りに失敗します。
        let request: Dictionary<String, Dictionary<String, Any>> = [
            "data": [
                "key":"value"
            ]
        ]
        functions.httpsCallable("function_name").call(request){ (result, error) in
            //エラーハンドリング
            if error != nil { // errorを使用する場合は if let error = error {　でも良いです。　使わないのに if letを使用すると注意されるので error != nil にしました。
                self.title = "エラー"
                self.message = "エラーが発生しました"
                self.isLoading = false
                self.isAlert = true
            }else{
                if let result = result {
                    datas = result.data as! NSDictionary
                    /*
                     受け取ったデータをここで操る
                     */
                    self.isLoading = false
                }else{
                    self.title = "エラー"
                    self.message = "エラーが発生しました"
                    self.isLoading = false
                    self.isAlert = true
                }
            }
        }
    }
    
    /*
     firestore内の任意の場所にデータをセットする
     setDataメソッドに「merge: true」を渡さないと、setしたフィールド以外全て消えるので注意
     
    */
    func db_set(){
        self.isLoading = true
        self.isAlert = false
        let data: Dictionary<String, Any> = [
            "key": "value"
        ]
        // 新規追加
        db.collection("collection_name").document("document_name").setData(data){ error in
            if error == nil {
                self.title = "確認"
                self.message = "更新が完了しました"
            }else{
                self.title = "エラー"
                self.message = "エラーが発生しました"
            }
        }
        // ドキュメント名が自由の場合
        db.collection("collection_name").addDocument(data: data)
        
        // フィールドの更新
        db.collection("collction_name").document("document_name").updateData(data)
        // or
        db.collection("collection_name").document("document_name").setData(data, merge: true)
        
    }
    
    // firestore内の任意の場所のフィールドを削除する
    func db_field_delete(){
        self.isLoading = true
        self.isAlert = false
        
        db.collection("colletion_name").document("document_name").setData(["key": FieldValue.delete()], merge: true){ error in
            if error == nil {
                self.title = "確認"
                self.message = "データの削除が完了しました"
            }else{
                self.title = "エラー"
                self.message = "エラーが発生しました"
            }
            self.isLoading = false
            self.isAlert = true
        }
    }
    
    // firestore内の任意の場所のドキュメントを削除する
    func db_document_delete(){
        self.isLoading = true
        self.isAlert = false
        
        db.collection("colletion_name").document("document_name").delete(){ error in
            if error == nil {
                self.title = "確認"
                self.message = "データの削除が完了しました"
            }else{
                self.title = "エラー"
                self.message = "エラーが発生しました"
            }
            self.isLoading = false
            self.isAlert = true
        }
    }
    
    /*
        クライアントからコレクションを削除することはFirebaseはお勧めしていないようです。
        コレクションの削除も行いたい場合は、httpsCallableからCloud functionsを呼び出し、サーバーサイドから削除するようにしてください。
    */
    
    // コレクションから複数のドキュメントまとめて取得する場合
    func db_collection_get(){
        self.isLoading = true
        self.isAlert = false
        
        db.collection("collection").getDocuments(){ (snapshot, error) in
            if error != nil {
                self.title = "エラー"
                self.message = "エラーが発生しました"
                self.isLoading = false
                self.isAlert = true
            }else{
                if let snapshot = snapshot {
                    for document in snapshot.documents{
                        debugPrint(document.documentID) // ドキュメント名
                        debugPrint(document.data()) //ドキュメント内のフィールド全部
                    }
                }else{
                    self.title = "エラー"
                    self.message = "データがありません"
                    self.isLoading = false
                    self.isAlert = true
                }
            }
        }
    }
    
    // 特定のドキュメントから取得する場合
    func db_document_get(){
        self.isLoading = true
        self.isAlert = false
        
        db.collection("collection_name").document("document_name").getDocument(){ (document, error) in
            if error != nil {
                self.title = "エラー"
                self.message = "エラーが発生しました"
                self.isLoading = false
                self.isAlert = true
            }else{
                if let document = document {
                    if let data = document.data(){
                        debugPrint(data) // ドキュメント内のフィールド全部
                        debugPrint(document.get("field_name")) //ドキュメント内の特定のフィールド
                        /*
                         getで取得した値はAny?型なので使用するときは適時キャストをする
                         強制キャストなのでフィールドネームが存在しなかった場合エラーになる
                        */
                        debugPrint(document.get("field_name") as! String)
                        debugPrint(document.get("field_name") as! Int)
                        
                        // 強制キャストしないデフォルトバリューを使用する
                        debugPrint(document.get("field_name") ?? "" )
                    }else{
                        self.title = "エラー"
                        self.message = "データがありません"
                        self.isLoading = false
                        self.isAlert = true
                    }
                }else{
                    self.title = "エラー"
                    self.message = "データがありません"
                    self.isLoading = false
                    self.isAlert = true
                }
            }
        }
    }
}
