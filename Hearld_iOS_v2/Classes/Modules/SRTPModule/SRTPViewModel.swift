//
//  SRTPViewModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 24/02/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON
import RxSwift
import RxCocoa
import RealmSwift
import YYCache

class SRTPViewModel {
    
    /// 单例
    static let shared = SRTPViewModel()
    
    private init() {
        
    }
    
    var srtpList : [SRTPModel] = []

    fileprivate let SRTPSubject = PublishSubject<[SRTPModel]>()
    var SRTPList: Observable<[SRTPModel]> {
        return SRTPSubject.asObservable()
    }
   
    let cache = YYMemoryCache.init()
    
    let bag = DisposeBag()
    
    func prepareData(isRefresh: Bool, completionHandler: @escaping ()->()) {
        if isRefresh {
            srtpList.removeAll()
            cache.removeObject(forKey: "strp")
            requestSRTP{ completionHandler() }
        } else {
            if let strpObjects = cache.object(forKey: "srtp") as? [SRTPModel], strpObjects.count > 0 {
                self.SRTPSubject.onNext(strpObjects)
                completionHandler()
            }else {
                srtpList.removeAll()
                requestSRTP{ completionHandler() }
            }
        }
    }
    
    private func requestSRTP(completionHandler: @escaping ()->()) {
        let provider = MoyaProvider<QueryAPI>()
        provider.request(.SRTP()) { (result) in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                let code = json["code"].stringValue
                if code == "200" {
                    self.parseSRTPModel(json)
                    self.SRTPSubject.onNext(self.srtpList)
                    completionHandler()
                } else if code == "408"{
                    self.SRTPSubject.onError(HeraldError.NetworkError)
                }
            case .failure(_):
                self.SRTPSubject.onError(HeraldError.NetworkError)
            }
        }
    }
    
    
    private func parseSRTPModel(_ json: JSON) {
        guard let realm = try? Realm() else {
            return
        }
        
        if let user = realm.objects(User.self).filter("uuid == '\(HearldUserDefault.uuid!)'").first{
            try! realm.write {
                user.points = json["result"]["info"]["points"].stringValue
                user.grade = json["result"]["info"]["grade"].stringValue
                realm.add(user, update: true)
            }
        }
        
        let srtpArrayValue = json["result"]["projects"].arrayValue
        
        for srtpJSON in srtpArrayValue {
            let date = srtpJSON["date"].stringValue
            let credit = srtpJSON["credit"].stringValue
            let type = srtpJSON["type"].stringValue
            let proportion = srtpJSON["proportion"].doubleValue
            let department = srtpJSON["department"].stringValue
            let total = srtpJSON["total"].stringValue
            let project = srtpJSON["project"].stringValue
            
            let srtpItem = SRTPModel(credit, date, department, project, proportion, total, type)
        
            srtpList.append(srtpItem)
        }
        cache.setObject(srtpList, forKey: "srtp")
    }
}
