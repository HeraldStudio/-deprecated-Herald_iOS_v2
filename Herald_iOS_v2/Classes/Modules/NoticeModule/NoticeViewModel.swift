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
import RxCocoa

class NoticeViewModel {
    
    fileprivate let noticeSubject = PublishSubject<[NoticeModel]>()
    
    var noticeList: Observable<[NoticeModel]> {
        return noticeSubject.asObservable()
    }
    
    // Cache
    var cache = YYMemoryCache()
    
    let bag = DisposeBag()
    
    func prepareData(isRefresh: Bool, completionHandler: @escaping () -> Void) {
        if isRefresh {
            cache.removeObject(forKey: "notice")
            requestNotice { completionHandler() }
        }  else {
            if let noticeObjects = cache.object(forKey: "Notice") as? [NoticeModel], noticeObjects.count > 0 {
                self.noticeSubject.onNext(noticeObjects)
            } else {
                requestNotice { completionHandler() }
            }
        }
    }
    
    private func requestNotice(completionHandler: @escaping () -> Void) {
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
        var noticeList: [NoticeModel] = []
        let noticeArray = json["result"].arrayValue
        for noticeJSON in noticeArray {
            let category = noticeJSON["category"].stringValue
            let title = noticeJSON["title"].stringValue
            let url = noticeJSON["url"].stringValue
            let isAttachment = noticeJSON["isAttachment"].stringValue
            let isImportant = noticeJSON["isImportant"].stringValue
            let initialTime = noticeJSON["time"].stringValue
            let time = initialTime.substring(NSRange(location: 0, length: initialTime.length()-3))
            let noticeItem = NoticeModel(category,
                                         title,
                                         url,
                                         isAttachment,
                                         isImportant,
                                         time)
            noticeList.append(noticeItem)
        }
        cache.setObject(noticeList, forKey: "notice")
        return noticeList
    }
}
