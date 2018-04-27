//
//  SRTPViewModel.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 24/02/2018.
//  Copyright © 2018 乔哲锋. All rights reserved.
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

    fileprivate let SRTPSubject = PublishSubject<[SRTPModel]>()
    var SRTPList: Observable<[SRTPModel]> {
        return SRTPSubject.asObservable()
    }
   
    let cache = YYMemoryCache.init()
    
    let bag = DisposeBag()
    
    func prepareData(isRefresh: Bool, completionHandler: @escaping ()->()) {
        if isRefresh {
            cache.removeObject(forKey: "strp")
            requestSRTP{ completionHandler() }
        } else {
            if let strpObjects = cache.object(forKey: "srtp") as? [SRTPModel], strpObjects.count > 0 {
                self.SRTPSubject.onNext(strpObjects)
            }else {
                requestSRTP{ completionHandler() }
            }
        }
    }
    
    func requestSRTP(completionHandler: @escaping ()->()) {
        var srtpList: [SRTPModel] = []

        let provider = MoyaProvider<QueryAPI>()
        provider.request(.SRTP()) { (result) in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                let code = json["code"].stringValue
                if code == "200" {
                    srtpList = self.parseSRTPModel(json)
                    self.SRTPSubject.onNext(srtpList)
                    completionHandler()
                } else if code == "408"{
                    self.SRTPSubject.onError(HeraldError.NetworkError)
                }
            case .failure(_):
                self.SRTPSubject.onError(HeraldError.NetworkError)
            }
        }
    }
    
    
    private func parseSRTPModel(_ json: JSON) -> [SRTPModel] {
        guard let realm = try? Realm() else {
            return []
        }
        
        var srtpList: [SRTPModel] = []
        
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
            let proportion = srtpJSON["proportion"].stringValue
            let department = srtpJSON["department"].stringValue
            let total = srtpJSON["total"].stringValue
            let project = srtpJSON["project"].stringValue
            
            let srtpItem = SRTPModel(credit, date, department, project, proportion, total, type)
            
            srtpList.append(srtpItem)
        }
        return srtpList
    }
}
