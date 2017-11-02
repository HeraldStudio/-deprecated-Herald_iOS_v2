//
//  ActivityModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 03/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

//命名与JSON数据保持一致
class ActivityModel: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var introduction: String = ""
    @objc dynamic var start_time: String = ""
    @objc dynamic var end_time: String = ""
    @objc dynamic var activity_time: String = ""
    @objc dynamic var detail_url: String = ""
    @objc dynamic var pic_url: String = ""
    @objc dynamic var association: String = ""
    @objc dynamic var location: String = ""
    
    override static func primaryKey() -> String? {
        return "title"
    }
}
