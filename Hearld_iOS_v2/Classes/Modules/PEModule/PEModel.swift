//
//  PEModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 31/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation

class PEModel: NSCoding {
    var name : String = ""
    var grade : String  = ""
    var score : Double = 0.0
    var value : Double = 0.0
    
    init(_ name : String,
         _ grade : String,
         _ score : Double,
         _ value : Double) {
        self.name = name
        self.grade = grade
        self.score = score
        self.value = value
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "pe_name") as! String
        self.grade = aDecoder.decodeObject(forKey: "pe_grade") as! String
        self.score = aDecoder.decodeDouble(forKey: "pe_score")
        self.value = aDecoder.decodeDouble(forKey: "pe_value")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "pe_name")
        aCoder.encode(self.grade, forKey: "pe_grade")
        aCoder.encode(self.score, forKey: "pe_score")
        aCoder.encode(self.value, forKey: "pe_value")
    }
}
