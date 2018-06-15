//
//  NoticeModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 22/04/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift
import SwiftDate

class NoticeModel: NSObject, NSCoding {
    var category: String
    var title: String
    var url: String
    var isAttachment: String
    var isImportant: String
    var time: String
    
    init(_ category: String,
         _ title: String,
         _ url: String,
         _ isAttachment: String,
         _ isImportant: String,
         _ time: String) {
        self.category = category
        self.title = title
        self.url = url
        self.isAttachment = isAttachment
        self.isImportant = isImportant
        self.time = time
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.category = aDecoder.decodeObject(forKey: "notice_category") as! String
        self.title = aDecoder.decodeObject(forKey: "notice_title") as! String
        self.url = aDecoder.decodeObject(forKey: "notice_url") as! String
        self.isAttachment = aDecoder.decodeObject(forKey: "notice_isAttachment") as! String
        self.isImportant = aDecoder.decodeObject(forKey: "notice_isImportant") as! String
        self.time = aDecoder.decodeObject(forKey: "notice_time") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.category, forKey: "notice_category")
        aCoder.encode(self.title, forKey: "notice_title")
        aCoder.encode(self.url, forKey: "notice_url")
        aCoder.encode(self.isAttachment, forKey: "notice_isAttachment")
        aCoder.encode(self.isImportant, forKey: "notice_isImportant")
        aCoder.encode(self.time, forKey: "notice_time")
    }
    
    var displayTime: String {
        return TimeConvertHelper.convert(from: calendar)
    }
    
    var calendar: Date {
        return TimeConvertHelper.convert(from: self.time)
    }
}
