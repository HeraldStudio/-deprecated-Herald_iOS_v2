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

public func db_addObjc(_ object: Object, with realm: Realm ){
    try! realm.write {
        realm.add(object)
    }
}

public func db_updateObjc(_ object: Object, with realm: Realm){
    try! realm.write {
        realm.add(object, update: true)
    }
}

public func db_deleteObjcs<T>(_ objects: Results<T>,with realm: Realm){
    try! realm.write {
        realm.delete(objects)
    }
}



