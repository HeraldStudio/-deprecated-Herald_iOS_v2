//
//  PEViewModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 31/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON
import RxSwift
import RxCocoa
import RealmSwift
// import YYCache

final class PEViewModel {
    var peModels: [PEModel] = []
    
    // 单例
    static let shared = PEViewModel()
    
    private init() { }
    
    fileprivate let PESubject = PublishSubject<[PEModel]>()
    var PEList: Observable<[PEModel]> {
        return PESubject.asObservable()
    }
    
    let cache = YYMemoryCache.init()
    
    fileprivate let semaphoreLock = DispatchSemaphore(value: 1)
    
    let bag = DisposeBag()
    
    func prepareData(isRefresh: Bool, completionHandler: @escaping () -> Void) {
        if isRefresh {
            lock()
            peModels.removeAll()
            cache.removeObject(forKey: "pe")
            requestPE{ completionHandler() }
        } else {
            if let peObjects = cache.object(forKey: "pe") as? [PEModel], peObjects.count > 0 {
                self.PESubject.onNext(peObjects)
                completionHandler()
            }else {
                lock()
                peModels.removeAll()
                requestPE{ completionHandler() }
            }
        }
    }
    
    private func requestPE(completionHandler: @escaping () -> Void) {
        let provider = MoyaProvider<QueryAPI>()
        provider.request(.PE()) { result in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                let code = json["code"].stringValue
                if code == "200" || code == "203"{
                    self.parsePEModel(json)
                    self.PESubject.onNext(self.peModels)
                    completionHandler()
                } else if code == "408"{
                    self.PESubject.onError(HeraldError.NetworkError)
                }
            case .failure(_):
                self.PESubject.onError(HeraldError.NetworkError)
                self.unlock()
            }
        }
    }
    
    private func parsePEModel(_ json: JSON) {
        guard let realm = try? Realm() else {
            return
        }
        
        if let user = realm.objects(User.self).filter("uuid == '\(HeraldUserDefault.uuid!)'").first{
            try! realm.write {
                user.peCount = json["result"]["count"].intValue
                realm.add(user, update: true)
            }
        }
        HeraldUserDefault.peDays = json["result"]["remainDays"].intValue
        
        let peArrayValue = json["result"]["health"].arrayValue
        
        for peJSON in peArrayValue {
            let name = peJSON["name"].stringValue
            let grade = peJSON["grade"].stringValue
            let score = peJSON["score"].doubleValue
            let value = peJSON["value"].doubleValue
            
            let peItem = PEModel(name, grade, score, value)
            
            peModels.append(peItem)
        }
        cache.setObject(peModels, forKey: "pe")
        unlock()
    }
}

extension PEViewModel {
    fileprivate func lock() {
        _ = semaphoreLock.wait(timeout: .distantFuture)
    }
    
    fileprivate func unlock() {
        semaphoreLock.signal()
    }
}
