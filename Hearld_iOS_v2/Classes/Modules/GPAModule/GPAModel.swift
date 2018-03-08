//
//  GPAModel.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 23/02/2018.
//  Copyright © 2018 乔哲锋. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import RxCocoa
import RxDataSources
import RxSwift

class GPAModel: Object {
    @objc dynamic var id = ""
    
    @objc dynamic var time = ""
    @objc dynamic var gpa = ""
    @objc dynamic var makeUpGPA = ""
    
    @objc dynamic var name = ""
    @objc dynamic var credit = ""
    @objc dynamic var semester = ""
    @objc dynamic var score = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}


