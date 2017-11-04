//
//  ActivityViewModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 03/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON
import Alamofire
import RealmSwift

class ActivityViewModel {
    
    var model: [ActivityModel] = []
    
    fileprivate let ActivitySubject = PublishSubject<[ActivityModel]>()
    var ActivityList: Observable<[ActivityModel]>{
        return ActivitySubject.asObservable()
    }
    let bag = DisposeBag()
    
    // 1.准备数据，若Refresh则发起网络请求更新数据库
    //   否则查询数据库，查询结果为空则发起网络请求。
    // 2.不管是从数据库读取，还是网络获取，都默认展示前8条活动信息，所以可默认清除model
    // 3.
    func prepareData(isRefresh: Bool, completionHandler: @escaping ()->()) {
        // 清空model
        self.model.removeAll()
        
        let realm = try! Realm()
        if isRefresh {
            // 清空数据库
            let results = realm.objects(ActivityModel.self)
            try! realm.write {
                realm.delete(results)
            }
            self.model.removeAll()
            // 发起网络请求
            requestActivities { completionHandler() }
        }else {
            let results = realm.objects(ActivityModel.self)
            if results.count > 0 {
                var activityList : [ActivityModel] = []
                for index in 0 ..< 8 {
                    activityList.append(results[index])
                }
                self.ActivitySubject.onNext(activityList)
            }else {
                requestActivities { completionHandler() }
            }
        }
    }
    
    // 请求下一页数据
    func requestNextPage(from page: String, completionHandler: @escaping ()->() ,failHandler: @escaping ()->()) {
        let provider = MoyaProvider<SubscribeAPI>()
        
        provider.request(.Activity(pageNumber: page)) { (result) in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                if json["content"].array?.count != 0{
                    var activityList : [ActivityModel] = []
                    activityList = self.parseActivityModel(json)
                    self.ActivitySubject.onNext(activityList)
                    completionHandler()
                }else{
                    failHandler()
                }
            case .failure(_):
                self.ActivitySubject.onError(HearldError.NetworkError)
            }
        }
    }
    
    // 默认请求第一页活动
    private func requestActivities(completionHandler: @escaping ()->()) {
        var activityList : [ActivityModel] = []
        let provider = MoyaProvider<SubscribeAPI>()
        
        provider.request(.ActivityDefault()) { (result) in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                activityList = self.parseActivityModel(json)
                self.ActivitySubject.onNext(activityList)
                completionHandler()
            case .failure(_):
                self.ActivitySubject.onError(HearldError.NetworkError)
            }
        }
    }
    
    private func parseActivityModel(_ json: JSON) -> [ActivityModel] {
        var activityList : [ActivityModel] = []
        
        let activities = json["content"].arrayValue
        for activityJSON in activities{
            //Parse activity
            let activity = ActivityModel()
            activity.title = activityJSON["title"].stringValue
            activity.introduction = activityJSON["introduction"].stringValue
            activity.start_time = activityJSON["start_time"].stringValue
            activity.end_time = activityJSON["end_time"].stringValue
            activity.activity_time = activityJSON["activity_time"].stringValue
            activity.detail_url = activityJSON["detail_url"].stringValue
            activity.pic_url = activityJSON["pic_url"].stringValue
            activity.association = activityJSON["association"].stringValue
            activity.location = activityJSON["location"].stringValue
            
            guard let realm = try? Realm() else {
                return []
            }
            updateObjc(activity, with: realm)
            activityList.append(activity)
        }
        return activityList
    }
}
