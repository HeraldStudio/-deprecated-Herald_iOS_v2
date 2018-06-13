//
//  Realm.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 23/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

// 增添数据库中对象
public func db_addObjc(_ object: Object, with realm: Realm ){
    try! realm.write {
        realm.add(object)
    }
}

// 更新数据库中对象
public func db_updateObjc(_ object: Object, with realm: Realm){
    try! realm.write {
        realm.add(object, update: true)
    }
}

// 删除数据库中所匹配的查询结果
public func db_deleteObjcs<T>(_ objects: Results<T>,with realm: Realm){
    try! realm.write {
        if !objects.isInvalidated && !objects.isEmpty {
            realm.delete(objects)
        }
    }
}



