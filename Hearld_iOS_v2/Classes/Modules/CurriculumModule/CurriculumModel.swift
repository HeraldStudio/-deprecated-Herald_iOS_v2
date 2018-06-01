//
//  CurriculumModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 01/06/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation

class CurriculumModel : NSCoding {
    var courseName : String = ""
    var credit : Int = 0
    var beginWeek : Int = 0
    var endWeek : Int = 0
    var location : String = ""
    var teacherName : String = ""
    var events : [EventModel] = []
    
    init(_ courseName : String,
         _ credit : Int,
         _ beginWeek : Int,
         _ endWeek : Int,
         _ location : String,
         _ teacherName : String,
         _ events : [EventModel]) {
        self.courseName = courseName
        self.credit = credit
        self.beginWeek = beginWeek
        self.endWeek = endWeek
        self.location = location
        self.teacherName = teacherName
        self.events = events
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.courseName = aDecoder.decodeObject(forKey: "curriculum_courseName") as! String
        self.credit = aDecoder.decodeInteger(forKey: "curriculum_credit")
        self.beginWeek = aDecoder.decodeInteger(forKey: "curriculum_beginWeek")
        self.endWeek = aDecoder.decodeInteger(forKey: "curriculum_endWeek")
        self.location = aDecoder.decodeObject(forKey: "curriculum_location") as! String
        self.teacherName = aDecoder.decodeObject(forKey: "curriculum_teacherName") as! String
        self.events = aDecoder.decodeObject(forKey: "curriculum_events") as! [EventModel]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.courseName, forKey: "curriculum_courseName")
        aCoder.encode(self.credit, forKey: "curriculum_credit")
        aCoder.encode(self.beginWeek, forKey: "curriculum_beginWeek")
        aCoder.encode(self.endWeek, forKey: "curriculum_endWeek")
        aCoder.encode(self.location, forKey: "curriculum_location")
        aCoder.encode(self.teacherName, forKey: "curriculum_teacherName")
        aCoder.encode(self.events, forKey: "curriculum_events")
    }
}
