import UIKit
import Alamofire

class StockMemos: NSObject {

    // 保存ボタンが押されたときに呼ばれるメソッドを定義
    class func postMemo(memo: Memo) {
      
      struct Params: Encodable {
        let text: String
      }
      
      let params = Params(text: memo.text)
      
      // HTTP通信
      AF.request("https://httpbin.org/post",
                 method: .post,
                 parameters: params,
                 encoder: JSONParameterEncoder.default).response { response in
          debugPrint(response)
      }
    }
}
