//
//  NoticeModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 22/04/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import RxCocoa
import RxDataSources
import RxSwift
import SwiftDate

class NoticeModel: Object {
    @objc dynamic var category = ""
    @objc dynamic var title = ""
    @objc dynamic var url = ""
    @objc dynamic var isAttachment = ""
    @objc dynamic var isImportant = ""
    @objc dynamic var nid = ""
    @objc dynamic var time = ""
    
    override static func primaryKey() -> String? {
        return "title"
    }
    
    var displayTime : String {
        var displayTime = ""
        let currentDate = DateInRegion(absoluteDate: Date(), in: Region.Local())
        let intervalInMonth = (currentDate - calendar).in(.month)!
        var intervalInDay = (currentDate - calendar).in(.day)!
        
        // 1.先判断是否是一个月以前通知
        // 2.再判断是否是这周的通知，用于取得「今天」和「昨天」的特殊事件
        // 3.之后为普通情况
        if intervalInMonth >= 1 {
            displayTime = number2Chinese(intervalInMonth) + "个月前"
        } else if intervalInDay <= 1{
            if intervalInDay == 0 {
                displayTime = "今天"
            } else if intervalInDay == 1 {
                displayTime = "昨天"
            }
        } else {
            while intervalInDay > 7 {
                intervalInDay = intervalInDay - 7
                displayTime += "上"
            }
            displayTime += "周"
            displayTime += weekDay2Chinese(calendar.weekdayName)
        }
        return displayTime
    }
    
    var calendar : DateInRegion {
        let seconds = Int64(self.time)
        let date = Date(timeIntervalSince1970: TimeInterval.init(seconds!))
        return DateInRegion(absoluteDate: date, in: Region.Local())
    }
    
    private func number2Chinese(_ number: Int) -> String {
        switch number {
        case 1:
            return "一"
        case 2:
            return "二"
        case 3:
            return "三"
        case 4:
            return "四"
        case 5:
            return "五"
        default:
            return "?"
        }
    }
    
    private func weekDay2Chinese(_ weekDay: String) -> String {
        switch weekDay {
        case "Monday":
            return "一"
        case "Tuesday":
            return "二"
        case "Wednesday":
            return "三"
        case "Thursday":
            return "四"
        case "Friday":
            return "五"
        case "Saturday":
            return "六"
        case "Sunday":
            return "日"
        default:
            return "?"
        }
    }
}
