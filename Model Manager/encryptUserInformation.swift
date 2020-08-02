import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class encryptUserInformation {
  func hoge() throws {
    let tagForPrivateKey = "com.example.keys.mykey".data(using: .utf8)!
    let attributes: [String: Any] = [
        kSecAttrKeyType as String: kSecAttrKeyTypeRSA, // 暗号鍵のタイプ（ここではRSAを指定）
        kSecAttrKeySizeInBits as String: 2048,         // 暗号鍵のビット数（2048-bitを指定）
        kSecPrivateKeyAttrs as String: [
            kSecAttrIsPermanent as String: true,       // keychainに保存するか否か
            kSecAttrApplicationTag as String: tagForPrivateKey] // タグを指定
    ]
    var error: Unmanaged<CFError>?
    //秘密鍵の作成
    guard let generatedPrivateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
        throw error!.takeRetainedValue() as Error
    }
    //公開鍵の作成
    let generatedPublicKey = SecKeyCopyPublicKey(generatedPrivateKey)

    print("privatekey: \(generatedPrivateKey)")
    print("publickey : \(generatedPublicKey! as Any)")
  }
  
  func encrypt() {
    do  {
      try hoge()
    } catch {
      return
    }
  }
}
