//
//  SRTPModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 23/02/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation

class SRTPModel: NSCoding {
    var credit: String
    var date: String
    var department: String
    var project: String
    var proportion: Double
    var total: String
    var type: String
    
    init(_ credit: String,
         _ date: String,
         _ department: String,
         _ project: String,
         _ proportion: Double,
         _ total: String,
         _ type: String) {
        self.credit = credit
        self.date = date
        self.department = department
        self.project = project
        self.proportion = proportion
        self.total = total
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.credit = aDecoder.decodeObject(forKey: "strp_credit") as! String
        self.date = aDecoder.decodeObject(forKey: "strp_date") as! String
        self.department = aDecoder.decodeObject(forKey: "strp_department") as! String
        self.project = aDecoder.decodeObject(forKey: "strp_project") as! String
        self.proportion = aDecoder.decodeDouble(forKey: "srtp_proportion")
        self.total = aDecoder.decodeObject(forKey: "strp_total") as! String
        self.type = aDecoder.decodeObject(forKey: "strp_type") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.credit, forKey: "strp_credit")
        aCoder.encode(self.date, forKey: "strp_date")
        aCoder.encode(self.department, forKey: "strp_department")
        aCoder.encode(self.project, forKey: "strp_project")
        aCoder.encode(self.proportion, forKey: "strp_proportion")
        aCoder.encode(self.total, forKey: "strp_total")
        aCoder.encode(self.type, forKey: "strp_type")
    }
}



