//
//  EventModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 01/06/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation

class EventModel: NSObject, NSCoding {
//    @objc dynamic var id : String = ""
//    @objc dynamic var week : Int = 0
//    @objc dynamic var startTime : String = ""
//    @objc dynamic var endTime : String = ""
    
    var week: Int = 0
    var startTime: String = ""
    var endTime: String = ""
    
    init(_ week: Int,
         _ startTime: String,
         _ endTime: String) {
        self.week = week
        self.startTime = startTime
        self.endTime = endTime
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.week = aDecoder.decodeInteger(forKey: "event_week")
        self.startTime = aDecoder.decodeObject(forKey: "event_startTime") as! String
        self.endTime = aDecoder.decodeObject(forKey: "event_endTime") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.week, forKey: "event_week")
        aCoder.encode(self.startTime, forKey: "event_startTime")
        aCoder.encode(self.endTime, forKey: "event_endTime")
    }
}
