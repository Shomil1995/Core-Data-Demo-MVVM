

import UIKit



class Global {
    static let shared = Global()

//    static let keychain = KeychainSwift()
    var isGoogleSignin = false
  
    var isTesting = true
    var storeURL: String?
    var appId : String = "040ecb4edd8c428f9bac2713b92018fd"
    var strStoreName = ""
    var strStoreCategory = ""
    var strStoreWebsiteUrl = ""
    var arrCategories: BehaviorRelay<[Category]> = .init(value: [])
    var arrSelectedCategoriesId: BehaviorRelay<[Int]> = .init(value: [])
   
}
