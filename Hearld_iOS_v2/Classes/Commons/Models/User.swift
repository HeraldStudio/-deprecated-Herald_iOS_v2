//
//  User.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 31/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
import Realm

class User : Object{
    @objc dynamic var cardID : String = ""
    @objc dynamic var username : String = ""
    @objc dynamic var uuid : String = ""
    @objc dynamic var sex : String = ""
    @objc dynamic var shchoolNum : String = ""
    @objc dynamic var identity : String = ""
    
    // GPA stuff
    @objc dynamic var gpa : String = ""
    @objc dynamic var gpaBeforeMakeup : String = ""
    @objc dynamic var gpaCalcutionTime : String = ""
    
    // STRP stuff
    @objc dynamic var points: String = ""
    @objc dynamic var grade: String = ""
    
    // Card stuff
    @objc dynamic var balance: Double = 0.0
    
    override static func primaryKey() -> String? {
        return "cardID"
    }
}
