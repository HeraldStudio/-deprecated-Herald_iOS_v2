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

class SRTPViewModel {
    var ModelOfSRTP: [SRTPModel] = []

    fileprivate let SRTPSubject = PublishSubject<[SRTPModel]>()
    var SRTPList: Observable<[SRTPModel]> {
        return SRTPSubject.asObservable()
    }
   
    let bag = DisposeBag()
    
    func prepareData(isRefresh: Bool, completionHandler: @escaping ()->()) {
        ModelOfSRTP.removeAll()

        let realm = try! Realm()
        if isRefresh {
            let resultOfSRTP = realm.objects(SRTPModel.self)
            db_deleteObjcs(resultOfSRTP, with: realm)

            requestSRTP{ completionHandler() }
        } else {
            let resultOfSRTP = realm.objects(SRTPModel.self)
            
            if resultOfSRTP.count > 0 {
                
                var srtpList: [SRTPModel] = []
                let count = resultOfSRTP.count
                for index in 0 ..< count {
                    srtpList.append(resultOfSRTP[index])
                }

                SRTPSubject.onNext(srtpList)
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
                srtpList = self.parseSRTPModel(json)
                
                self.SRTPSubject.onNext(srtpList)
                completionHandler()
            case .failure(_):
                self.SRTPSubject.onError(HearldError.NetworkError)
            }
        }
    }
    
    
    private func parseSRTPModel(_ json: JSON) -> [SRTPModel] {
        //解析返回的JSON数据
        var srtpList: [SRTPModel] = []
        let srtp = json["result"]["projects"].arrayValue
        
//        let srtpItem = SRTPModel()
//        srtpItem.allTotal = srtp[0]["points"].stringValue
//        srtpItem.score = srtp[0]["grade"].stringValue
//        guard let realm = try? Realm() else {
//            return []
//        }
//        db_updateObjc(srtpItem, with: realm)
//        srtpList.append(srtpItem)
        //print(realm.configuration.fileURL)
        
        for srtpJSON in srtp {
            let srtpItem = SRTPModel()
            srtpItem.id = srtpJSON["project"].stringValue
//            srtpItem.total = srtpJSON["total credit"].stringValue
            srtpItem.date = srtpJSON["date"].stringValue
            srtpItem.credit = srtpJSON["credit"].stringValue
            srtpItem.type = srtpJSON["type"].stringValue
            srtpItem.proportion = srtpJSON["proportion"].stringValue
            srtpItem.department = srtpJSON["department"].stringValue
            
            guard let realm = try? Realm() else {
                return []
            }
            db_updateObjc(srtpItem, with: realm)
            srtpList.append(srtpItem)
        }
        return srtpList
    }
}
