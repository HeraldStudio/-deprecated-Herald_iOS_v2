//
//  NoticeViewModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 22/04/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON
import RxSwift
import RealmSwift
import RxCocoa

class NoticeViewModel {
    
    fileprivate let noticeSubject = PublishSubject<[NoticeModel]>()
    var noticeList : Observable<[NoticeModel]> {
        return noticeSubject.asObservable()
    }
    
    let bag = DisposeBag()
    
    func prepareData(isRefresh: Bool, completionHandler: @escaping ()->()) {
        let realm = try! Realm()
        if isRefresh {
            let resultOfNotice = realm.objects(NoticeModel.self)
            db_deleteObjcs(resultOfNotice, with: realm)
            
            requestNotice { completionHandler() }
        }  else {
            let resultOfNotice = realm.objects(NoticeModel.self)
            if resultOfNotice.count > 0 {
                var noticeList: [NoticeModel] = []
                resultOfNotice.forEach { noticeList.append($0) }
                self.noticeSubject.onNext(noticeList)
            } else {
                requestNotice { completionHandler() }
            }
        }
    }
    
    private func requestNotice(completionHandler: @escaping ()->()) {
        var noticeList : [NoticeModel]  = []
        let provider = MoyaProvider<QueryAPI>()
        provider.request(.Notice()) { result in
            switch result {
            case .success(let response):
                let data = response.data
                let json = JSON(data)
                let code = json["code"].stringValue
                if code == "200" {
                    noticeList = self.parseNoticeModel(json)
                    self.noticeSubject.onNext(noticeList)
                    completionHandler()
                }
            case .failure(_):
                self.noticeSubject.onError(HeraldError.NetworkError)
            }
        }
    }
    
    private func parseNoticeModel(_ json: JSON) -> [NoticeModel] {
        guard let realm = try? Realm() else {
            return []
        }
        var noticeList : [NoticeModel] = []
        let noticeArray = json["result"].arrayValue
        for noticeJSON in noticeArray {
            let noticeItem = NoticeModel()
            noticeItem.category = noticeJSON["category"].stringValue
            noticeItem.title = noticeJSON["title"].stringValue
            noticeItem.url = noticeJSON["url"].stringValue
            noticeItem.isAttachment = noticeJSON["isAttachment"].stringValue
            noticeItem.isImportant = noticeJSON["isImportant"].stringValue
            noticeItem.time = noticeJSON["time"].stringValue
            noticeItem.time = noticeItem.time.substring(NSRange(location: 0, length: noticeItem.time.length()-3))
            
            db_updateObjc(noticeItem, with: realm)
            noticeList.append(noticeItem)
        }
        return noticeList
    }
}
