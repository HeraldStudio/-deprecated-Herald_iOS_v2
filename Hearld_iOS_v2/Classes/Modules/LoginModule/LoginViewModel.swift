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

struct LoginViewModel{
    var model : LoginModel?
    
    fileprivate let loginInfoSubject = PublishSubject<String>()
    var loginInfo: Observable<String>{
        return loginInfoSubject.asObservable()
    }
    let bag = DisposeBag()
    
    func requestLogin(){
        
    }
}
