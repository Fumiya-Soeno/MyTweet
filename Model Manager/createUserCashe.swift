import Foundation

class createUserCashe {
  let encrypt = encryptUserInformation()
  // キャッシュの存在確認とログイン
  func confirmCasheExist() {
    let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first! + "/UserCashe"
    if FileManager.default.fileExists(atPath: path) {
      print("cashes exist.")
      let email = readCashe().0
      let encryptPassword = readCashe().1
      do{
        let privateKey = try encrypt.readSecretKeyFunction()
        let password = try encrypt.decrypt(cipherTextString: encryptPassword, privateKey: privateKey)
      } catch let error as NSError {
        print(error)
      }
    } else {
      print("cashes don't exist.")
    }
  }
  
  // キャッシュの削除
  func deleteCashe() {
    let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first! + "/UserCashe"
    do {
      if FileManager.default.fileExists(atPath: path) {
        try FileManager.default.removeItem(atPath: path)
        print("cashes deleted.")
      } else {
        print("cashes don't exist.")
      }
    } catch {
        print("error")
    }
  }
  
  // キャッシュの保存
  func createCashe(email: String, encryptedPassword: String) {
    // パスを作成
    let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first! + "/UserCashe"
    do {
      // ディレクトリが存在するかどうかの判定
      if !FileManager.default.fileExists(atPath: path) {
        // ディレクトリが無い場合ディレクトリを作成する
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false , attributes: nil)
      }
    } catch let error as NSError {
      print(error)
    }
    
    // 保存先のパスを作成
    let saveEmailPath = path + "/UserEmail.txt"
    let savePasswordPath = path + "/UserPassword.txt"
    // 書き込み
    do {
      try email.write(toFile: saveEmailPath, atomically: true, encoding: String.Encoding.utf8)
      try encryptedPassword.write(toFile: savePasswordPath, atomically: true, encoding: String.Encoding.utf8)
    } catch let error as NSError {
      print("failed to write: \(error)")
    }
    // ファイルから読み込みんで表示
    let emailFile = FileHandle(forReadingAtPath: saveEmailPath)!
    let passwordFile = FileHandle(forReadingAtPath: savePasswordPath)!
    
    let emailContentData = emailFile.readDataToEndOfFile()
    let passwordContentData = passwordFile.readDataToEndOfFile()
    
    let emailContentString = String(data: emailContentData, encoding: .utf8)!
    let passwordContentString = String(data: passwordContentData, encoding: .utf8)!
    
    print("emailContentString:\(emailContentString)")
    print("passwordContentString:\(passwordContentString)")
    
    passwordFile.closeFile()
    emailFile.closeFile()
    
  }
  
  func readCashe() -> (String, String){
    let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first! + "/UserCashe"
    let saveEmailPath = path + "/UserEmail.txt"
    let savePasswordPath = path + "/UserPassword.txt"
    print(path)
    let emailFile = FileHandle(forReadingAtPath: saveEmailPath)!
    let passwordFile = FileHandle(forReadingAtPath: savePasswordPath)!
    let emailContentData = emailFile.readDataToEndOfFile()
    let passwordContentData = passwordFile.readDataToEndOfFile()
    let emailContentString = String(data: emailContentData, encoding: .utf8)!
    let passwordContentString = String(data: passwordContentData, encoding: .utf8)!
    passwordFile.closeFile()
    emailFile.closeFile()
    return(emailContentString,passwordContentString)
  }
}
