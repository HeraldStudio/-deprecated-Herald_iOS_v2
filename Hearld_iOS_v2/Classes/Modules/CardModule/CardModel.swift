//
//  CardModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 10/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation

class CardModel : NSCoding {
    var amount: Double
    var desc: String
    var time: String
    
    init(_ amount: Double,
         _ desc: String,
         _ time: String) {
        self.amount = amount
        self.desc = desc
        self.time = time
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.amount = aDecoder.decodeDouble(forKey: "card_amount")
        self.desc = aDecoder.decodeObject(forKey: "card_desc") as! String
        self.time = aDecoder.decodeObject(forKey: "card_time") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.amount, forKey: "card_amount")
        aCoder.encode(self.desc, forKey: "card_desc")
        aCoder.encode(self.time, forKey: "card_time")
    }
}
