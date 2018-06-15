//
//  CardViewModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 10/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON
import RxSwift
import RxCocoa
import RealmSwift
import SwiftDate

class CardViewModel {
    
    // 提供单例
    static let shared = CardViewModel()
    
    private init() {
        
    }
    
    // Model
    var cardModels : [CardModel] = []
    
    // Subject
    fileprivate let cardSubject = PublishSubject<[CardModel]>()
    var cardList: Observable<[CardModel]> {
        return cardSubject.asObservable()
    }
    
    // 单例Cache和bag
    let cache = YYMemoryCache()
    let bag = DisposeBag()
    
    fileprivate let semaphoreLock = DispatchSemaphore(value: 1)
    
    var offset = 0
    
    // 请求日期
    var requestDate : String {
        get {
            var currentDate = Date()
            currentDate = currentDate - offset.day
            return currentDate.string(format: .custom("yyyy-MM-dd"))
        }
    }
    
    /// - Parameter isExpand: 是否加载前一天支出,叠加Model
    func prepareData(isExpand: Bool, completionHandler: @escaping () -> Void) {
        if isExpand {
            offset += 1
            requestCard{ completionHandler() }
        } else {
            prepareData(isRefresh: false, completionHandler: completionHandler)
        }
    }
    
    /// 封装从缓存获取或是网络请求获取的逻辑
    func prepareData(isRefresh: Bool, completionHandler: @escaping () -> Void ) {
        if isRefresh {
            lock()
            offset = 0
            cardModels.removeAll()
            cache.removeObject(forKey: "card")
            requestCard{ completionHandler() }
        } else {
            if let cardObjects = cache.object(forKey: "card") as? [CardModel], cardObjects.count > 0 {
                self.cardSubject.onNext(cardObjects)
                completionHandler()
            }else {
                lock()
                cardModels.removeAll()
                requestCard{ completionHandler() }
            }
        }
    }
    
    /// 网络请求API
    private func requestCard(completionHandler: @escaping () -> Void) {
        // Moya工厂方法
        let provider = MoyaProvider<QueryAPI>()
        provider.request(.CardRecord(date: requestDate)) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                let code = json["code"].stringValue
                if code == "200" {
                    self.parseCardModel(json)
                    self.cardSubject.onNext(self.cardModels)
                    completionHandler()
                } else if code == "408"{
                    self.cardSubject.onError(HeraldError.NetworkError)
                }
            case let .failure(_):
                self.cardSubject.onError(HeraldError.NetworkError)
                self.unlock()
            }
        }
    }
    
    /// 解析CardModel JSON数据
    private func parseCardModel(_ json: JSON) {
        guard let realm = try? Realm() else {
            return
        }
        
        if let user = realm.objects(User.self).filter("uuid == '\(HeraldUserDefault.uuid!)'").first {
            try! realm.write {
                user.balance = json["result"]["info"]["balance"].doubleValue
                realm.add(user, update: true)
            }
        }
        
        let cardArrayValue = json["result"]["detail"].arrayValue
        
        for cardJSON in cardArrayValue {
            let amount = cardJSON["amount"].doubleValue
            let desc = cardJSON["desc"].stringValue
            let time = cardJSON["time"].stringValue
            let tempTime = time.substring(NSRange(location: 0, length: time.length()-3))
            let date = TimeConvertHelper.convert(from: tempTime)
            let displayTime = TimeConvertHelper.convert(from: date)
            
            let cardModel = CardModel(amount, desc, displayTime)
            cardModels.append(cardModel)
        }
        cache.setObject(cardModels, forKey: "card")
        unlock()
    }
}

extension CardViewModel {
    fileprivate func lock() {
        _ = semaphoreLock.wait(timeout: .distantFuture)
    }
    
    fileprivate func unlock() {
        semaphoreLock.signal()
    }
}
