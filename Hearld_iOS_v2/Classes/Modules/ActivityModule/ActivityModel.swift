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
import RxDataSources
import RxSwift
import RxCocoa

/// 命名与JSON数据保持一致
class ActivityModel: Object {
//    var identity: String = "title"
//    typealias Identity = String
    
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
    
    /// 活动状态的枚举类，以 String 为值，便于直接显示
    enum ActivityState : String {
        case Coming = "即将开始"
        case Going = "进行中"
        case Gone = "已结束"
    }
    
    /// 开始时间，用 GCalendar 表示
    var start : GCalendar {
        return GCalendar(start_time)
    }
    
    /// 结束时间，用 GCalendar 表示
    var end : GCalendar {
        return GCalendar(end_time)
    }
    
    /// 活动状态，用枚举表示
    var state : ActivityState {
        let now = GCalendar(.Day)
        if now < start {
            return .Coming
        }
        if now <= end {
            return .Going
        }
        if now > end {
            return .Gone
        }
        return .Gone
    }
    
    public func db_delete(with realm: Realm){
        realm.delete(self)
    }
}
