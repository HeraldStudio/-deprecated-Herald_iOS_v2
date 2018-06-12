//
//  HeraldUserDefault.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 23/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

let screenRect = UIScreen.main.bounds

// 登录状态Variable //
let isLoginVariable = Variable<Bool>(false)

let isRemindLesson = Variable<Bool>(false)
let isRemindExperiment = Variable<Bool>(false)
let isRemindTest = Variable<Bool>(false)

class HeraldUserDefault{
    
    // Keys //
    static let uuidKey = "uuid"
    static let isLoginKey = "isLogin"
    
    static let remainPEDays = "remainPE"
    static let currentTermKey = "currentTerm"
    
    static let isRemindLessonKey = "remindLesson"
    static let isRemindExperimentKey = "remindExperiment"
    static let isRemindTestKey = "remindTest"
    
    static let defaults = UserDefaults.standard
    
    public static var isLogin: Bool? {
        set{
            set(isLoginKey,newValue)
            if let value = newValue{
                isLoginVariable.value = value
            }
        }
        get{
            return get(isLoginKey) ?? nil
        }
    }
    
    public static var uuid: String? {
        set{
            set(uuidKey,newValue)
        }
        get{
            return get(uuidKey) ?? nil
        }
    }
    
    public static var peDays: Int? {
        set {
            set(remainPEDays, newValue)
        }
        get {
            return get(remainPEDays) ?? nil
        }
    }
    
    public static var currentTerm: String? {
        set {
            set(currentTermKey, newValue)
        }
        get {
            return get(currentTermKey) ?? nil
        }
    }
    
    // 清除UserDefault //
    public func cleanAllUserDefault(){
        HeraldUserDefault.defaults.removeObject(forKey: HeraldUserDefault.uuidKey)
        HeraldUserDefault.defaults.removeObject(forKey: HeraldUserDefault.isLoginKey)
        HeraldUserDefault.defaults.removeObject(forKey: HeraldUserDefault.isRemindLessonKey)
        HeraldUserDefault.defaults.removeObject(forKey: HeraldUserDefault.isRemindExperimentKey)
        HeraldUserDefault.defaults.removeObject(forKey: HeraldUserDefault.isRemindTestKey)
    }
    
    class func set<T>(_ key: String, _ value: T) {
        HeraldUserDefault.defaults.set(value, forKey: key)
    }
    
    class func get<T>(_ key: String) -> T? {
        if let value = HeraldUserDefault.defaults.object(forKey: key){
            return value as? T
        }
        return nil
    }
    
}
