//
//  CurriculumModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 01/06/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class CurriculumModel : Object {    
    @objc dynamic var courseName : String = ""
    @objc dynamic var credit : Int = 0
    @objc dynamic var beginWeek : Int = 0
    @objc dynamic var endWeek : Int = 0
    @objc dynamic var location : String = ""
    @objc dynamic var teacherName : String = ""
    let events = List<EventModel>()
}
