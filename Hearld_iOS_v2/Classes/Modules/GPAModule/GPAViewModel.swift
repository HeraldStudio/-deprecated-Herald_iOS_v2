//
//  GPAViewModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 23/02/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON
import RxSwift
import RealmSwift
import RxCocoa
import YYCache

class GPAViewModel {
    
    var gpaModels : [GPAModel] = []
    
    /// 单例
    static let shared = GPAViewModel()
    
    private init() {
        
    }
    
    fileprivate let GPASubject = PublishSubject<[GPAModel]>()
    var GPAList: Observable<[GPAModel]>{
        return GPASubject.asObservable()
    }
    
    let cache = YYMemoryCache.init()
    
    let bag = DisposeBag()
    
    func prepareData(isRefresh: Bool, completionHandler: @escaping ()->()) {
        if isRefresh {
            gpaModels.removeAll()
            // 清空缓存
            cache.removeObject(forKey: "gpa")
            // 发起网络请求
            requestGPA { completionHandler() }
        }else {
            // 查询缓存
            if let gpaObjects = cache.object(forKey: "gpa") as? [GPAModel], gpaObjects.count > 0 {
                self.GPASubject.onNext(gpaObjects)
                completionHandler()
            } else {
                gpaModels.removeAll()
                // 缓存为空，发起网络请求
                requestGPA { completionHandler() }
            }
        }
    }
    
    func requestGPA(completionHandler: @escaping ()->()) {

        let provider = MoyaProvider<QueryAPI>()
        provider.request(.GPA()) { (result) in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                let code = json["code"].stringValue
                if code == "200" {
                    self.parseGPAModel(json)
                    self.GPASubject.onNext(self.gpaModels)
                    completionHandler()
                } else if code == "408"{
                    self.GPASubject.onError(HeraldError.NetworkError)
                }
            case .failure(_):
                self.GPASubject.onError(HeraldError.NetworkError)
            }
        }
    }
    
    private func parseGPAModel(_ json: JSON) {
        guard let realm = try? Realm() else {
            return
        }

        // 基础GPA信息
        if let user = realm.objects(User.self).filter("uuid == '\(HearldUserDefault.uuid!)'").first{
            try! realm.write {
                user.gpa = json["result"]["gpa"].stringValue
                user.gpaBeforeMakeup = json["result"]["gpaBeforeMakeup"].stringValue
                user.gpaCalcutionTime = json["result"]["calculationTime"].stringValue
                realm.add(user, update: true)
            }
        }
        
        // 具体课程信息
        let gpaArrayValue = json["result"]["detail"].first?.1["courses"].arrayValue
        for gpaJSON in gpaArrayValue! {
            let courseName = gpaJSON["courseName"].stringValue
            let credit = gpaJSON["credit"].stringValue
            let score = gpaJSON["score"].stringValue
            let semester = gpaJSON["semester"].stringValue
            let scoreType = gpaJSON["scoreType"].stringValue
            
            let gpaItem = GPAModel(courseName, credit, score, semester, scoreType)
            gpaModels.append(gpaItem)
        }
        cache.setObject(gpaModels, forKey: "gpa")
    }
    
}



