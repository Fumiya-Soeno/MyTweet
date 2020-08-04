import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class encryptUserInformation {
  func decrypt(cipherTextString: String, privateKey: SecKey) throws -> (String) {
    //string型の暗号文をbase64でデコードし、data型に変換
    let decryptedCipherText = Data(base64Encoded: cipherTextString, options: [])
    //復号に使用するアルゴリズムを定義（暗号化に使用したアルゴリズムと同様）
    let algorithm: SecKeyAlgorithm = .rsaEncryptionOAEPSHA512
    //指定した秘密鍵が、上記のアルゴリズムをサポートしているか検証
    var error: Unmanaged<CFError>?
    guard SecKeyIsAlgorithmSupported(privateKey, .decrypt, algorithm) else {
        throw error!.takeRetainedValue() as Error
    }
//    //暗号文と秘密鍵のblock長を比較
//    guard cipherTextString.count == SecKeyGetBlockSize(privateKey) else {
//        throw error!.takeRetainedValue() as Error
//    }
    //data型に変換した暗号文を復号
    guard let clearText = SecKeyCreateDecryptedData(
        privateKey,
        algorithm,
        decryptedCipherText! as CFData,
        &error
        ) as Data? else {
          throw error!.takeRetainedValue() as Error
        }
    //復号したデータを、string型に変換
    if let clearTextString: String = String(data: clearText, encoding: .utf8){
      return clearTextString
    } else {
      return ""
    }
  }
  
  func encrypt(publicKey: SecKey, plainText: String) throws -> (String) {
    //暗号化に使用するアルゴリズムを定義
    let algorithm: SecKeyAlgorithm = .rsaEncryptionOAEPSHA512
    //指定した公開鍵が、上記のアルゴリズムをサポートしているか検証
    var error: Unmanaged<CFError>?
    guard SecKeyIsAlgorithmSupported(publicKey, .encrypt, algorithm) else {
        throw error!.takeRetainedValue() as Error
    }
    //平文と公開鍵のblock長を比較
    guard (plainText.count < (SecKeyGetBlockSize(publicKey)-130)) else {
        throw error!.takeRetainedValue() as Error
    }
    //平文をData型に変換
    let plainTextData = plainText.data(using: .utf8)!
    //平文の暗号化
    guard let cipherText = SecKeyCreateEncryptedData(
        publicKey,
        algorithm,
        plainTextData as CFData,
        &error
        ) as Data? else {
            throw error!.takeRetainedValue() as Error
    }
    //暗号化した平文をbase64でデコードし、string型に変換
    let cipherTextString = cipherText.base64EncodedString()
    return(cipherTextString)
  }

  func generateKeyPairFunction() throws -> (SecKey) {
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
    guard let generatedPrivateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else { throw error!.takeRetainedValue() as Error }
    //公開鍵の作成
    do {
      let generatedPublicKey = try SecKeyCopyPublicKey(readSecretKeyFunction())
      return generatedPublicKey!
    } catch {
      return SecKeyCopyPublicKey(generatedPrivateKey)!
    }
  }
  
  func readSecretKeyFunction() throws -> (SecKey) {
    //取得する秘密鍵のタグを指定
    let tagForPrivateKey = "com.example.keys.mykey".data(using: .utf8)! //秘密鍵の作成の際につけたタグを指定
    //秘密鍵を検索するクエリを作成
    let getquery: [String: Any] = [
        kSecClass as String: kSecClassKey, //取得する情報の種類(暗号鍵、証明書、パスワードなど)
        kSecAttrApplicationTag as String: tagForPrivateKey, //秘密鍵についているタグ
        kSecAttrKeyType as String: kSecAttrKeyTypeRSA, //秘密鍵のタイプ
        kSecReturnRef as String: true //秘密鍵の参照情報を取得するか否か（この参照情報を使用して公開鍵の作成などを行う）
    ]
    var item: CFTypeRef?
    let status = SecItemCopyMatching(getquery as CFDictionary, &item)
    //秘密鍵が取得できたかどうか検証
    var error: Unmanaged<CFError>?
    guard status == errSecSuccess else {
        throw error!.takeRetainedValue() as Error
    }
    //取得した秘密鍵を、変数retrievedPrivateKeyに代入
    let retrievedPrivateKey = item as! SecKey
    return retrievedPrivateKey
  }
}
