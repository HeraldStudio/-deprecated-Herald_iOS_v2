//
//  EventModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 01/06/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class EventModel : Object {
    @objc dynamic var id : String = ""
    @objc dynamic var week : Int = 0
    @objc dynamic var startTime : String = ""
    @objc dynamic var endTime : String = ""
}
