//
//  SRTPModel.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 23/02/2018.
//  Copyright © 2018 乔哲锋. All rights reserved.
//

import Foundation
import RxSwift
import Realm
import RealmSwift
import RxCocoa

class SRTPModel: Object {
    //为图省事SRTP只用一套数据库的Model
    //实际值为card number或者project
    @objc dynamic var id = ""
    
    @objc dynamic var score = ""
    @objc dynamic var allTotal = ""
    
    @objc dynamic var credit = ""
    @objc dynamic var proportion = ""
    @objc dynamic var department = ""
    @objc dynamic var date = ""
    @objc dynamic var type = ""
    @objc dynamic var total = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}



