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
import YYCache

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
    let cache = YYMemoryCache.init()
    let bag = DisposeBag()
    
    // 暴露的API，封装从缓存获取或是网络请求获取的逻辑
    func prepareData(isRefresh: Bool, completionHandler: @escaping ()->() ) {
        if isRefresh {
            cardModels.removeAll()
            cache.removeObject(forKey: "card")
            requestCard{ completionHandler() }
        } else {
            if let cardObjects = cache.object(forKey: "card") as? [CardModel], cardObjects.count > 0 {
                self.cardSubject.onNext(cardObjects)
                completionHandler()
            }else {
                cardModels.removeAll()
                requestCard{ completionHandler() }
            }
        }
    }
    
    // 网络请求API
    private func requestCard(completionHandler: @escaping ()->()) {
        // Moya工厂方法
        let provider = MoyaProvider<QueryAPI>()
        provider.request(.Card()) { result in
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
            }
        }
    }
    
    // 解析CardModel JSON数据
    private func parseCardModel(_ json: JSON) {
        guard let realm = try? Realm() else {
            return
        }
        
        if let user = realm.objects(User.self).filter("uuid == '\(HearldUserDefault.uuid!)'").first{
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
            
            let cardModel = CardModel(amount, desc, time)
            cardModels.append(cardModel)
        }
        cache.setObject(cardModels, forKey: "card")
    }
}
