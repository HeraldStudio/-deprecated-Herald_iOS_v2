//
//  InfoModel.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 08/03/2018.
//  Copyright © 2018 乔哲锋. All rights reserved.
//
/*
import Foundation
import RealmSwift
import Realm

class InfoModel : Object{
    @objc dynamic var title : String = ""
    @objc dynamic var detail : String = ""
    
    override static func primaryKey() -> String? {
        return "title"
    }
}
*/

import Foundation

class InfoModel {
    var title: String
    var detail : String
    
    init(_ title: String,_ detail: String) {
        self.title = title
        self.detail = detail
    }
    
}
