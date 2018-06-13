//
//  ActivityModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 03/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa

/// 命名与API返回JSON数据保持一致
class ActivityModel: NSCoding {
    
    var title: String
    var introduction: String
    var start_time: String
    var end_time: String
    var activity_time: String
    var detail_url: String
    var pic_url: String
    var association: String
    var location: String
    
    init(_ title: String,
         _ introduction: String,
         _ start_time: String,
         _ end_time: String,
         _ activity_time: String,
         _ detail_url: String,
         _ pic_url: String,
         _ association: String,
         _ location: String) {
        self.title = title
        self.introduction = introduction
        self.start_time = start_time
        self.end_time = end_time
        self.activity_time = activity_time
        self.detail_url = detail_url
        self.pic_url = pic_url
        self.association = association
        self.location = location
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: "activity_title") as! String
        self.introduction = aDecoder.decodeObject(forKey: "activity_introduction") as! String
        self.start_time = aDecoder.decodeObject(forKey: "activity_start_time") as! String
        self.end_time = aDecoder.decodeObject(forKey: "activity_end_time") as! String
        self.activity_time = aDecoder.decodeObject(forKey: "activity_activity_time") as! String
        self.detail_url = aDecoder.decodeObject(forKey: "activity_detail_url") as! String
        self.pic_url = aDecoder.decodeObject(forKey: "activity_pic_url") as! String
        self.association = aDecoder.decodeObject(forKey: "activity_association") as! String
        self.location = aDecoder.decodeObject(forKey: "activity_location") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "activity_title")
        aCoder.encode(self.introduction, forKey: "activity_introduction")
        aCoder.encode(self.start_time, forKey: "activity_start_time")
        aCoder.encode(self.end_time, forKey: "activity_end_time")
        aCoder.encode(self.activity_time, forKey: "activity_activity_time")
        aCoder.encode(self.detail_url, forKey:"activity_detail_url")
        aCoder.encode(self.pic_url, forKey: "activity_pic_url")
        aCoder.encode(self.association, forKey: "activity_association")
        aCoder.encode(self.location, forKey: "activity_location")
    }
    
    private func extensionKey(_ key: String) -> String {
        return "activity_" + key
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
}
