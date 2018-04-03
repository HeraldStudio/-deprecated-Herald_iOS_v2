//
//  LectureViewModel.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 14/02/2018.
//  Copyright © 2018 乔哲锋. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON
import RxSwift
import RealmSwift
import RxCocoa

class LectureViewModel {
    
    var model: [LectureModel] = []
    
    fileprivate let LectureSubject = PublishSubject<[LectureModel]>()
    var LectureList: Observable<[LectureModel]>{
        return LectureSubject.asObservable()
    }
    
    let bag = DisposeBag()
    
    //仿照ActivityViewModel写的数据准备函数
    //根据是否refresh判断是否发起网络请求
    func prepareData(isRefresh: Bool, completionHandler: @escaping ()->()) {
        // 清空model
        self.model.removeAll()
        
        let realm = try! Realm()
        if isRefresh {
            // 清空数据库
            let results = realm.objects(LectureModel.self)
            db_deleteObjcs(results, with: realm)

            // 发起网络请求
            requestLectures { completionHandler() }
        }else {
            // 查询数据库
            let results = realm.objects(LectureModel.self)
            if results.count > 0 {
                
                /*
                let lectureList : [LectureModel] = Array(results)
                self.LectureSubject.onNext(lectureList)
                */
                
                var lectureList : [LectureModel] = []
                let count = results.count 
                for index in 0 ..< count {
                    lectureList.append(results[index])
                }
                self.LectureSubject.onNext(lectureList)
                
            }else {
                // 数据库为空，发起网络请求
                requestLectures { completionHandler() }
            }
        }
    }
    
    func requestLectures(completionHandler: @escaping ()->()) {
        var lectureList : [LectureModel] = []
        let provider = MoyaProvider<QueryAPI>()
        provider.request(.Lecture()) { (result) in
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                lectureList = self.parseLectureModel(json)
                self.LectureSubject.onNext(lectureList)
                completionHandler()
            case .failure(_):
                self.LectureSubject.onError(HearldError.NetworkError)
            }
        }
    }
    
    private func parseLectureModel(_ json: JSON) -> [LectureModel] {
        //解析返回的JSON数据
        var lectureList : [LectureModel] = []
        let lectures = json["result"].arrayValue

        for lectureJSON in lectures{
            let lecture = LectureModel()
//            lecture.place = lectureJSON["place"].stringValue
//
//            let dateTime = lectureJSON["date"].stringValue.components(separatedBy: " ")
//            lecture.date = dateTime[0]
//            lecture.time = dateTime[1]
            lecture.time = lectureJSON["time"].stringValue
            lecture.place = lectureJSON["location"].stringValue
            
            guard let realm = try? Realm() else {
                return []
            }
            db_updateObjc(lecture, with: realm)
            lectureList.append(lecture)
        }
       
        return lectureList
    }
        
}

