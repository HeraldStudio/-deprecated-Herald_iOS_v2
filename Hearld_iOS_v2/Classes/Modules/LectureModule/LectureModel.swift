//
//  LectureModel.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 14/02/2018.
//  Copyright © 2018 乔哲锋. All rights reserved.
//

import Foundation
import RxCocoa
import Realm
import RealmSwift
import RxDataSources
import RxSwift

class LectureModel: Object {
    @objc dynamic var date:String = ""
    @objc dynamic var place:String = ""
    @objc dynamic var time:String = ""
    
    override static func primaryKey() -> String? {
        return "time"
    }
    
    public func db_delete(with realm: Realm){
        realm.delete(self)
    }
}
