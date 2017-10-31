//
//  LoginViewModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 23/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import Alamofire
import SwiftyJSON
import Realm
import RealmSwift

struct LoginViewModel{
    var model : LoginModel?
    let user = User()
    
    fileprivate let loginInfoSubject = PublishSubject<String>()
    var loginInfo: Observable<String>{
        return loginInfoSubject.asObservable()
    }
    let bag = DisposeBag()
    
    func requestLogin(){
        guard let cardID = model?.cardID, let password = model?.password else{
            return
        }
        
        let provider = MoyaProvider<UserAPI>()
        provider.request(.Login(userID: cardID, password: password)) { (result) in
            switch result{
            case let .success(moyaResponse):
                //Response body
                let data = moyaResponse.data
                let NSuuid = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                let uuid = NSuuid! as String
                self.user.uuid = uuid
                HearldUserDefault.uuid = uuid
                self.checkUUID()
            case .failure(_):
                self.loginInfoSubject.onError(HearldError.NetworkError)
            }
        }
    }
    
    func checkUUID() {
        let provider = MoyaProvider<UserAPI>()
        provider.request(.Info()) { (result) in
            switch result{
            case let .success(moyaResponse):
                let schoolNum = JSON(moyaResponse.data)["content"]["schoolnum"].stringValue
                if (moyaResponse.response?.statusCode == 200 && schoolNum.characters.count == 8){
                    let data = moyaResponse.data
                    let json = JSON(data)
                    print(json)
                    
                    self.user.username = json["content"]["name"].stringValue
                    self.user.cardID = json["content"]["cardnum"].stringValue
                    self.user.sex = json["content"]["sex"].stringValue
                    self.user.shchoolNum = json["content"]["schoolnum"].stringValue
                    
                    guard let realm = try? Realm() else {
                        return
                    }
                    updateObjc(self.user, with: realm)
                    HearldUserDefault.isLogin = true
//                    self.loginInfoSubject.onNext("ok")
                }else{
                    self.loginInfoSubject.onError(HearldError.UserNotExist)
                }
            case .failure(_):
                self.loginInfoSubject.onError(HearldError.NetworkError)
            }
        }
    }
}
