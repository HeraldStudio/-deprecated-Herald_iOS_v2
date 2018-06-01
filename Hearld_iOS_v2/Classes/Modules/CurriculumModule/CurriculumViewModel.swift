//
//  CurriculumViewModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 01/06/2018.
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
import SwiftDate

class CurriculumViewModel {
    
    /* 单例 */
    static let shared = CurriculumViewModel()
    
    private init() {}
    
    /* Model */
    var curriculumModels : [CurriculumModel] = []
    
    /* Subject */
    fileprivate let curriculumSubject = PublishSubject<[[CurriculumModel]]>()
    var curriculumTable: Observable<[[CurriculumModel]]> {
        return curriculumSubject.asObservable()
    }
    
    let bag = DisposeBag()
    
    func prepareData(isRefresh: Bool, completionHandler: @escaping ()->()) {
        
    }
    
    private func requestCurriculum(completionHandler: @escaping ()->()) {
        let provider = MoyaProvider<QueryAPI>()
        provider.request(.Curriculum(term: "17-18-3")) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                let code = json["code"].stringValue
                if code == "200" {
                    self.parseCurriculumModel(json)
            
                    self.curriculumSubject.onNext(self.formatModel(self.curriculumModels))
                    completionHandler()
                } else if code == "408"{
                    self.curriculumSubject.onError(HeraldError.NetworkError)
                }
            case let .failure(_):
                self.curriculumSubject.onError(HeraldError.NetworkError)
            }
        }
    }
    
    private func parseCurriculumModel(_ json : JSON) {
        guard let realm = try? Realm() else {
            return
        }
        
        let curriculumArrayValue = json["result"]["curriculum"].arrayValue
        
        for curriculumJSON in curriculumArrayValue {
            let courseName = curriculumJSON["courseName"].stringValue
            let teacherName = curriculumJSON["teacherName"].stringValue
            let location = curriculumJSON["location"].stringValue
            let credit = curriculumJSON["credit"].intValue
            let beginWeek = curriculumJSON["beginWeek"].intValue
            let endWeek = curriculumJSON["endWeek"].intValue
            
            var events : [EventModel] = []
            let eventArrayValue = curriculumJSON["events"].arrayValue
            for eventJSON in eventArrayValue {
                let week = eventJSON["week"].intValue
                let startTime = eventJSON["startTime"].stringValue
                let endTime = eventJSON["endTime"].stringValue
                let event = EventModel.init(week, startTime, endTime)
                events.append(event)
            }
            let curriculum = CurriculumModel.init(courseName, credit, beginWeek, endWeek, location, teacherName, events)
            curriculumModels.append(curriculum)
        }
//        db_addObjc(curriculumModels, with: realm)
    }
    
    private func formatModel(_ model : [CurriculumModel]) -> [[CurriculumModel]] {
        return []
    }
}
