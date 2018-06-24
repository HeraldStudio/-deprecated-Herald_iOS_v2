//
//  User.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 31/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class User: Object{
    @objc dynamic var cardID: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var uuid: String = ""
    @objc dynamic var sex: String = ""
    @objc dynamic var shchoolNum: String = ""
    @objc dynamic var identity: String = ""

    // GPA stuff
    @objc dynamic var gpa: String = ""
    @objc dynamic var gpaBeforeMakeup: String = ""
    @objc dynamic var gpaCalcutionTime: String = ""

    // STRP stuff
    @objc dynamic var points: String = ""
    @objc dynamic var grade: String = ""

    // Card stuff
    @objc dynamic var balance: Double = 0.0

    // PE stuff
    @objc dynamic var peCount: Int = 0

    override static func primaryKey() -> String? {
        return "cardID"
    }
    
//    var cardID: String = ""
//    var username: String = ""
//    var uuid: String = ""
//    var sex: String = ""
//    var shchoolNum: String = ""
//    var identity: String = ""
//
//    // GPA stuff
//    var gpa: String = ""
//    var gpaBeforeMakeup: String = ""
//    var gpaCalcutionTime: String = ""
//
//    // STRP stuff
//    var points: String = ""
//    var grade: String = ""
//
//    // Card stuff
//    var balance: Double = 0.0
//
//    // PE stuff
//    var peCount: Int = 0
//
//    init(_ cardID: String,
//         _ username: String,
//         _ uuid: String,
//         _ sex: String,
//         _ shchoolNum: String,
//         _ identity: String,
//         _ gpa: String,
//         _ gpaBeforeMakeup: String,
//         _ gpaCalcutionTime: String,
//         _ points: String,
//         _ grade: String,
//         _ balance: Double,
//         _ peCount: Int) {
//        self.cardID = cardID
//        self.username = username
//        self.uuid = uuid
//        self.sex = sex
//        self.shchoolNum = shchoolNum
//        self.identity = identity
//        self.gpa = gpa
//        self.gpaBeforeMakeup = gpaBeforeMakeup
//        self.gpaCalcutionTime = gpaCalcutionTime
//        self.points = points
//        self.grade = grade
//        self.balance = balance
//        self.peCount = peCount
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        self.cardID = aDecoder.decodeObject(forKey: "user_cardID") as! String
//        self.username = aDecoder.decodeObject(forKey: "user_username") as! String
//        self.uuid = aDecoder.decodeObject(forKey: "user_uuid") as! String
//        self.sex = aDecoder.decodeObject(forKey: "user_sex") as! String
//        self.shchoolNum = aDecoder.decodeObject(forKey: "user_shchoolNum") as! String
//        self.identity = aDecoder.decodeObject(forKey: "user_identity") as! String
//        self.gpa = aDecoder.decodeObject(forKey: "user_gpa") as! String
//        self.gpaBeforeMakeup = aDecoder.decodeObject(forKey: "user_gpaBeforeMakeup") as! String
//        self.gpaCalcutionTime = aDecoder.decodeObject(forKey: "user_gpaCalcutionTime") as! String
//        self.points = aDecoder.decodeObject(forKey: "user_points") as! String
//        self.grade = aDecoder.decodeObject(forKey: "user_grade") as! String
//        self.balance = aDecoder.decodeDouble(forKey: "user_balance")
//        self.peCount = aDecoder.decodeInteger(forKey: "user_peCount")
//    }
}
