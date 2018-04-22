//
//  NoticeModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 22/04/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import RxCocoa
import RxDataSources
import RxSwift

class NoticeModel: Object {
    @objc dynamic var category = ""
    @objc dynamic var title = ""
    @objc dynamic var url = ""
    @objc dynamic var isAttachment = ""
    @objc dynamic var isImportant = ""
    @objc dynamic var nid = ""
    @objc dynamic var time = ""
    
    override static func primaryKey() -> String? {
        return "title"
    }
}
