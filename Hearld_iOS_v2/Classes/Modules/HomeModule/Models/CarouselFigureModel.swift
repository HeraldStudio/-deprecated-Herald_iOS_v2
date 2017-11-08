//
//  CarouselFigureModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 08/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class CarouselFigureModel : Object{
    @objc dynamic var title : String = ""
    @objc dynamic var link : String = ""
    @objc dynamic var picture_url : String = ""
    
    override static func primaryKey() -> String? {
        return "title"
    }
}
