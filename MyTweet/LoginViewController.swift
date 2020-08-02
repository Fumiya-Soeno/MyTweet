import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    struct loginParams: Encodable {
      let account_name         : String
      let account_id           : String
      let email                : String
      let password             : String
      let password_confirmation: String
    }
    
  func CreateNewUser(userParams: loginParams){
    let params = userParams
    AF.request("http://46.51.241.223/users",
               method: .post,
               parameters: params,
               encoder: JSONParameterEncoder.default).responseJSON { response in
                switch response.result{
                  case .success:
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainStoryboard")
                    vc?.loadView()
                    vc?.viewDidLoad()
                    self.navigationController?.popViewController(animated: true)
                  case .failure(let error):
                    print(error)
                }
    }
  }
  
    override func viewDidLoad() {
      super.viewDidLoad()
      userNameText.placeholder = "ユーザー名"
      userIdText.placeholder = "ユーザーID"
      emailText.placeholder = "メールアドレス"
      passwordText.placeholder = "パスワード"
      passwordConfirmationText.placeholder = "パスワード(確認)"
      passwordText.isSecureTextEntry = true
      passwordConfirmationText.isSecureTextEntry = true
    }
  
  @IBOutlet weak var userNameText: UITextField!
  @IBOutlet weak var userIdText: UITextField!
  @IBOutlet weak var emailText: UITextField!
  @IBOutlet weak var passwordText: UITextField!
  @IBOutlet weak var passwordConfirmationText: UITextField!
  @IBAction func LoginButtonAction(_ sender: Any) {
    let login = Login()
    login.account_name = userNameText.text ?? ""
    login.account_id = userIdText.text ?? ""
    login.email = emailText.text ?? ""
    login.password = passwordText.text ?? ""
    login.password_confirmation = passwordConfirmationText.text ?? ""
    CreateNewUser(userParams: LoginViewController.loginParams(account_name: userNameText.text ?? "", account_id: userIdText.text ?? "", email: emailText.text ?? "", password: passwordText.text ?? "", password_confirmation: passwordConfirmationText.text ?? ""))
  }
}
