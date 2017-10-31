//
//  LoginModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 23/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation

class LoginModel{
    var cardID : String
    var password : String
    
    init(_ cardID : String, _ password : String) {
        self.cardID = cardID
        self.password = password
    }
}
