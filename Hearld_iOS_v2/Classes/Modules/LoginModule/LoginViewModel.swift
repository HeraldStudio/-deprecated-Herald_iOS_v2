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
    
    // fileprivate防止非法访问
    fileprivate let loginInfoSubject = PublishSubject<String>()
    var loginInfo: Observable<String>{
        return loginInfoSubject.asObservable()
    }
    let bag = DisposeBag()
    
    // 登录request函数
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
                let json = JSON(data)
                let uuid = json["result"].stringValue
                self.user.uuid = uuid
                HearldUserDefault.uuid = uuid
                self.checkUUID()
            case .failure(_):
                self.loginInfoSubject.onError(HeraldError.NetworkError)
            }
        }
    }
    
    func checkUUID() {
        let provider = MoyaProvider<UserAPI>()
        provider.request(.Info()) { (result) in
            switch result{
            case let .success(moyaResponse):
                let schoolNum = JSON(moyaResponse.data)["result"]["schoolnum"].stringValue
                if (moyaResponse.response?.statusCode == 200 && schoolNum.characters.count == 8){
                    let data = moyaResponse.data
                    let json = JSON(data)
                    self.user.username = json["result"]["name"].stringValue
                    self.user.cardID = json["result"]["cardnum"].stringValue
                    self.user.shchoolNum = json["result"]["schoolnum"].stringValue
                    self.user.identity = json["result"]["identity"].stringValue
                    
                    guard let realm = try? Realm() else {
                        return
                    }
                    
                    db_updateObjc(self.user, with: realm)
                    HearldUserDefault.isLogin = true
                    self.loginInfoSubject.onNext("ok")
                }else{
                    self.loginInfoSubject.onError(HeraldError.UserNotExist)
                }
            case .failure(_):
                self.loginInfoSubject.onError(HeraldError.NetworkError)
            }
        }
    }
}
