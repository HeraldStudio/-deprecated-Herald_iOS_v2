//
//  GPAModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 23/02/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift

class GPAModel: NSCoding {
    var courseName: String
    var credit: String
    var score: String
    var semester: String
    var scoreType: String
    
    init(_ courseName: String,
         _ credit: String,
         _ score: String,
         _ semester: String,
         _ scoreType: String) {
        self.courseName = courseName
        self.score = score
        self.credit = credit
        self.semester = semester
        self.scoreType = scoreType
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.courseName = aDecoder.decodeObject(forKey: "gpa_courseName") as! String
        self.credit = aDecoder.decodeObject(forKey: "gpa_credit") as! String
        self.score = aDecoder.decodeObject(forKey: "gpa_score") as! String
        self.semester = aDecoder.decodeObject(forKey: "gpa_semester") as! String
        self.scoreType = aDecoder.decodeObject(forKey: "gpa_scoreType") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.courseName, forKey: "gpa_courseName")
        aCoder.encode(self.credit, forKey: "gpa_credit")
        aCoder.encode(self.score, forKey: "gpa_score")
        aCoder.encode(self.semester, forKey: "gpa_semester")
        aCoder.encode(self.scoreType, forKey: "gpa_scoreType")
    }
}


