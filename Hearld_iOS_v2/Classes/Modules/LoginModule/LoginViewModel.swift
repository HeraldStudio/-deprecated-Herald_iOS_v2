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

struct LoginViewModel{
    var model : LoginModel?
    
    fileprivate let loginInfoSubject = PublishSubject<String>()
    var loginInfo: Observable<String>{
        return loginInfoSubject.asObservable()
    }
    let bag = DisposeBag()
    
    func requestLogin(){
        guard let username = model?.username, let password = model?.password else{
            return
        }
        
        let provider = MoyaProvider<UserAPI>()
        
        provider.request(.Login(userID: username, password: password)) { (result) in
            switch result{
            case let .success(moyaResponse):
//                let response = moyaResponse.response
                // save to Cache
                HearldUserDefault.ifLogin = true
//                HearldUserDefault.uuid =
                
//                self.loginInfoSubject.onNext(self.model)
            case .failure(_):
                self.loginInfoSubject.onError(NetworkError.CannotGetServerResponse)
            }
        }
    }
}
