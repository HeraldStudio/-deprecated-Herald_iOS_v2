//
//  GPAViewModel.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 23/02/2018.
//  Copyright © 2018 乔哲锋. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON
import RxSwift
import RealmSwift
import RxCocoa

class GPAViewModel {
    
    var modelOfGPA: [GPAModel] = []
    
    fileprivate let GPASubject = PublishSubject<[GPAModel]>()
    var GPAList: Observable<[GPAModel]>{
        return GPASubject.asObservable()
    }
    
    let bag = DisposeBag()
    
    func prepareData(isRefresh: Bool, completionHandler: @escaping ()->()) {
        // 清空model
        self.modelOfGPA.removeAll()
        
        let realm = try! Realm()
        if isRefresh {
            // 清空数据库
            let resultOfGPA = realm.objects(GPAModel.self)
            db_deleteObjcs(resultOfGPA, with: realm)
            
            // 发起网络请求
            requestGPA { completionHandler() }
        }else {
            // 查询数据库
            let resultOfGPA = realm.objects(GPAModel.self)
            if resultOfGPA.count > 0 {
                
                var gpaList : [GPAModel] = []
                let count = resultOfGPA.count
                for index in 0 ..< count {
                    gpaList.append(resultOfGPA[index])
                }
                
                self.GPASubject.onNext(gpaList)
            
            }else {
                // 数据库为空，发起网络请求
                requestGPA { completionHandler() }
            }
            
        }
    }
    
    func requestGPA(completionHandler: @escaping ()->()) {
        var gpaList : [GPAModel] = []

        let provider = MoyaProvider<QueryAPI>()
        provider.request(.GPA()) { (result) in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                let code = json["code"].stringValue
                if code == "200" {
                    gpaList = self.parseGPAModel(json)
                    self.GPASubject.onNext(gpaList)
                    completionHandler()
                } else if code == "408"{
                    self.GPASubject.onError(HeraldError.NetworkError)
                }
            case .failure(_):
                self.GPASubject.onError(HeraldError.NetworkError)
            }
        }
    }
    
    private func parseGPAModel(_ json: JSON) -> [GPAModel] {
        //解析返回的JSON数据
        var gpaList : [GPAModel] = []
        
        let gpaItem = GPAModel()
        gpaItem.makeUpGPA = json["result"]["gpa"].stringValue
        gpaItem.gpa = json["result"]["gpaBeforeMakeup"].stringValue
        gpaItem.time = json["result"]["calculationTime"].stringValue
        
        guard let realm = try? Realm() else {
            return []
        }
        //获取一卡通号
        let cardNum = realm.objects(User.self).filter("uuid == '\(HearldUserDefault.uuid!)'").first?.cardID
        gpaItem.id = cardNum!
        
        db_updateObjc(gpaItem, with: realm)
        gpaList.append(gpaItem)
        
        for gpaJSON in json["result"]["detail"].arrayValue {
            let gpaItem = GPAModel()
            gpaItem.name = gpaJSON["name"].stringValue
            gpaItem.semester = gpaJSON["semester"].stringValue
                
            //暂时使用name+type+semester的形式来作为GPAModel的主键
            gpaItem.id = gpaItem.name + gpaJSON["type"].stringValue + gpaItem.semester
                
            gpaItem.credit = gpaJSON["credit"].stringValue
            gpaItem.score = gpaJSON["score"].stringValue
                
            guard let realm = try? Realm() else {
                return []
            }
            db_updateObjc(gpaItem, with: realm)
            gpaList.append(gpaItem)
        }
        return gpaList
    }
    
}



