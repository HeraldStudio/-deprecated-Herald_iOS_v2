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
    
    func prepareData() {
        requestActivities()
    }
    
    private func requestActivities() {
        let provider = MoyaProvider<SubscribeAPI>()
        
        provider.request(.Activity()) { (result) in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                self.model = self.parseActivityModel(json)
                self.ActivitySubject.onNext(self.model)
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
