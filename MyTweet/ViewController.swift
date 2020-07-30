import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
  let screenSize = UIScreen.main.bounds.size
  let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 300, height: 500))
  struct Params: Encodable {
    let text: String
  }
  
  func genTweetPreviews(scrollView: UIScrollView, tweetParams: Params) {
    var tweetPreviews = Array<UITextView>()
    let params = tweetParams
    AF.request("http://46.51.241.223/api/memos",
               method: .post,
               parameters: params,
               encoder: JSONParameterEncoder.default).responseJSON { response in
                switch response.result{

                  case .success:
                    guard let json = response.data else{
                        return
                    }
                    var count = 1
                    for tweets in JSON(json)["tweet"] {
                      let tweetPreview = UITextView(frame: CGRect(x: 0, y: 0, width: self.screenSize.width, height: 28))
                      tweetPreview.text = "\(tweets.1["created_at"]) \(tweets.1["text"])"
                      tweetPreview.textColor = .black
                      tweetPreview.backgroundColor = .green
                      tweetPreview.isEditable = false
                      tweetPreview.layer.position = CGPoint(x: Int(self.screenSize.width)/2, y: 29*(count))
                      tweetPreviews.append(tweetPreview)
                      count += 1
                    }
                    
                    scrollView.contentSize = CGSize(width: 300, height: (tweetPreviews.count+1)*29)
                    scrollView.frame.size.width = self.screenSize.width
                    scrollView.layer.position = CGPoint(x: self.screenSize.width/2, y: self.screenSize.height/2+100)

                    for tweetPreview in tweetPreviews{
                      scrollView.addSubview(tweetPreview)
                    }

                  case .failure(let error):
                    print(error)
                }
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(scrollView)
    genTweetPreviews(scrollView: scrollView, tweetParams: Params(text: ""))
  }
  
  @IBAction func tapSaveBtn(_ sender: Any) {
    let memo = Memo()
    func postMemo(memo: Memo) {
      memo.text = textView.text
      genTweetPreviews(scrollView: self.scrollView, tweetParams: ViewController.Params(text: memo.text))
    }
    postMemo(memo: memo)
  }
  
  @IBOutlet weak var textView: UITextView!
  

}

