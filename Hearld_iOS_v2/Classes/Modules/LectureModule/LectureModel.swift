//
//  LectureModel.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 14/02/2018.
//  Copyright © 2018 乔哲锋. All rights reserved.
//

import Foundation

class LectureModel: NSCoding {
    var location: String = ""
    var time: String = ""
    
    init(_ location: String,
         _ time: String) {
        self.location = location
        self.time = time
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.location = aDecoder.decodeObject(forKey: "lecture_location") as! String
        self.time = aDecoder.decodeObject(forKey: "lecture_time") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.location, forKey: "lecture_location")
        aCoder.encode(self.time, forKey: "lecture_time")
    }
}
