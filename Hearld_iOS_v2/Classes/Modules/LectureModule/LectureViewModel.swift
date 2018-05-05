//
//  LectureViewModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 14/04/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON
import RxSwift
import RxCocoa
import YYCache

final class LectureViewModel {
    
    var lectureModels : [LectureModel] = []
    
    /// 单例
    static let shared = LectureViewModel()
    
    private init() {
        
    }
    
    fileprivate let LectureSubject = PublishSubject<[LectureModel]>()
    var LectureList: Observable<[LectureModel]>{
        return LectureSubject.asObservable()
    }
    
    let cache = YYMemoryCache.init()
    
    let bag = DisposeBag()
    
    func prepareData(isRefresh: Bool, completionHandler: @escaping ()->()) {

        if isRefresh {
            cache.removeObject(forKey: "lecture")
            lectureModels.removeAll()
            requestLectures { completionHandler() }
        }else {
            if let lectureObjects = cache.object(forKey: "lecture") as? [LectureModel], lectureObjects.count > 0 {
                self.LectureSubject.onNext(lectureObjects)
                completionHandler()
            }else {
                lectureModels.removeAll()
                requestLectures { completionHandler() }
            }
        }
    }
    
    func requestLectures(completionHandler: @escaping ()->()) {
        let provider = MoyaProvider<QueryAPI>()
        provider.request(.Lecture()) { (result) in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                let code = json["code"].stringValue
                if code == "200" {
                    self.parseLectureModel(json)
                    self.LectureSubject.onNext(self.lectureModels)
                    completionHandler()
                } else if code == "408"{
                    self.LectureSubject.onError(HeraldError.NetworkError)
                }
            case .failure(_):
                self.LectureSubject.onError(HeraldError.NetworkError)
            }
        }
    }
    
    private func parseLectureModel(_ json: JSON) {
        //解析返回的JSON数据
        let lectureArrayValue = json["result"].arrayValue

        for lectureJSON in lectureArrayValue{
            var time = lectureJSON["time"].stringValue
            time = time.substring(NSRange(location: 0, length: time.length()-3))
            let location = lectureJSON["location"].stringValue
            let lecture = LectureModel(location, time)
            
            lectureModels.append(lecture)
        }
        cache.setObject(lectureModels, forKey: "lecture")
    }
        
}

