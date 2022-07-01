import Foundation
import Firebase
import FirebaseInstanceID
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging


class firebase_test: ObservableObject{
    @Published var isError: Bool = false
    @Published var isLoading: Bool = false
    
    let db = Firestore.firestore()
    var functions = Functions.functions()
    
    func http_connect(){
        // 初期化
        self.isError = false
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
                self.isLoading = false
                self.isError = true
            }else{
                if let result = result {
                    datas = result.data as! NSDictionary
                    /*
                     受け取ったデータをここで操る
                     */
                    self.isLoading = false
                }else{
                    self.isLoading = false
                    self.isError = true
                }
            }
        }
    }
}
