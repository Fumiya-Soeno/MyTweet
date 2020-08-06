import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
  let userCashe = createUserCashe()
  let userInfo = encryptUserInformation()
  
  struct loginParams: Encodable {
    let account_name         : String
    let account_id           : String
    let email                : String
    let password             : String
    let password_confirmation: String
  }
  
  struct sessionParams: Encodable {
    let email    : String
    let password : String
  }
  
  func CreateNewUser(userParams: loginParams){
    let params = userParams
    AF.request("http://46.51.241.223/users",
               method: .post,
               parameters: params,
               encoder: JSONParameterEncoder.default).responseJSON { response in
                switch response.result{
                  case .success:
                    print("success")
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
    CreateNewUser(userParams: LoginViewController.loginParams(account_name: userNameText.text ?? "", account_id: userIdText.text ?? "", email: emailText.text ?? "", password: passwordText.text ?? "", password_confirmation: passwordConfirmationText.text ?? ""))
    do {
      let encryptedPassword = try userInfo.encrypt(publicKey: userInfo.generateKeyPairFunction() , plainText: passwordText.text ?? "")
      userCashe.createCashe(email: emailText.text ?? "", encryptedPassword: encryptedPassword)
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainStoryboard")
      vc?.loadView()
      vc?.viewDidLoad()
      self.navigationController?.popViewController(animated: true)
    } catch {
      return
    }
  }
  
  @IBOutlet weak var loginEmailText: UITextField!
  @IBOutlet weak var loginPasswordText: UITextField!
  @IBAction func loginButton(_ sender: Any) {
    let params = LoginViewController.sessionParams(email: loginEmailText.text ?? "", password: loginPasswordText.text ?? "")

    AF.request("http://46.51.241.223/users/sign_in",
               method: .post,
               parameters: params,
               encoder: JSONParameterEncoder.default).responseJSON { response in
                switch response.result{
                  case .success:
                  print("success")
                  case .failure(let error):
                    print(error)
                }
    }
    do {
      let encryptedPassword = try userInfo.encrypt(publicKey: userInfo.generateKeyPairFunction() , plainText: loginPasswordText.text ?? "")
      userCashe.createCashe(email: loginEmailText.text ?? "", encryptedPassword: encryptedPassword)
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainStoryboard")
      vc?.loadView()
      vc?.viewDidLoad()
      self.navigationController?.popViewController(animated: true)
    } catch {
      return
    }
  }
}
