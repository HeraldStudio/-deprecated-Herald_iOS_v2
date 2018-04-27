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
import YYCache

class ActivityViewModel {
    
    var model: [ActivityModel] = []
    
    fileprivate let ActivitySubject = PublishSubject<[ActivityModel]>()
    var ActivityList: Observable<[ActivityModel]>{
        return ActivitySubject.asObservable()
    }
    let bag = DisposeBag()
    private let cache = YYMemoryCache.init()
    
    // 1.准备数据，若Refresh则发起网络请求更新缓存
    //   否则查询缓存，查询结果为空则发起网络请求。
    // 2.不管是从缓存读取，还是网络获取，都默认展示前8条活动信息，所以可默认清除model
    func prepareData(isRefresh: Bool, completionHandler: @escaping ()->()) {
        // 清空model
        self.model.removeAll()
        
        if isRefresh {
            // 清空缓存
            cache.removeObject(forKey: "activity")
            // 发起网络请求
            requestActivities { completionHandler() }
        }else {
            // 查询缓存
            if let activityObjects = cache.object(forKey: "activity") as? [ActivityModel], activityObjects.count > 0 {
                var activityList : [ActivityModel] = []
                let ceiling = activityObjects.count >= 8 ? 8 : activityObjects.count
                for index in 0 ..< ceiling {
                    activityList.append(activityObjects[index])
                }
                self.ActivitySubject.onNext(activityList)
            }else {
                // 缓存为空，发起网络请求
                requestActivities { completionHandler() }
            }
        }
    }
    
    // 请求下一页数据
    // 不清空model,即直接在model上添加下一页的list
    func requestNextPage(from page: String, completionHandler: @escaping ()->() ,failedHandler: @escaping ()->()) {
        let provider = MoyaProvider<SubscribeAPI>()
        
        provider.request(.Activity(pageNumber: page)) { (result) in
            var activityList : [ActivityModel] = []
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                if json["content"].array?.count != 0{
                    activityList = self.parseActivityModel(json)
                    self.ActivitySubject.onNext(activityList)
                    completionHandler()
                }else{
                    failedHandler()
                }
            case .failure(_):
                self.ActivitySubject.onError(HeraldError.NetworkError)
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
                self.ActivitySubject.onError(HeraldError.NetworkError)
            }
        }
    }
    
    private func parseActivityModel(_ json: JSON) -> [ActivityModel] {
        var activityList : [ActivityModel] = []
        
        let activities = json["content"].arrayValue
        for activityJSON in activities{
            //Parse activity
            let title = activityJSON["title"].stringValue
            let introduction = activityJSON["introduction"].stringValue
            let start_time = activityJSON["start_time"].stringValue
            let end_time = activityJSON["end_time"].stringValue
            let activity_time = activityJSON["activity_time"].stringValue
            let detail_url = activityJSON["detail_url"].stringValue
            let pic_url = activityJSON["pic_url"].stringValue
            let association = activityJSON["association"].stringValue
            let location = activityJSON["location"].stringValue
            let activity = ActivityModel(title,
                                         introduction,
                                         start_time,
                                         end_time,
                                         activity_time,
                                         detail_url,
                                         pic_url,
                                         association,
                                         location)
            activityList.append(activity)
        }
        // 存入缓存中
        cache.setObject(activityList, forKey: "activity")
        return activityList
    }
}
