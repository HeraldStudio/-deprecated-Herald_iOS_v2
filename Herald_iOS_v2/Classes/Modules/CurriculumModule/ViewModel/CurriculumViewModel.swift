//
//  CurriculumViewModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 01/06/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Alamofire
import Foundation
import Moya
import RxSwift
import RxCocoa
import SwiftyJSON
import SwiftDate

typealias curriculumItem = [CurriculumModel]

class CurriculumViewModel {

    // 单例
    static let shared = CurriculumViewModel()

    private init() {
        let path = basePath! + "/Curriculum"
        cache = YYDiskCache.init(path: path)!
    }

    // Model
    var curriculumModels: [CurriculumModel] = []
    var eventModels: [EventModel] = []

    // Subject
    fileprivate let curriculumSubject = PublishSubject<[curriculumItem]>()
    var curriculumTable: Observable<[curriculumItem]> {
        return curriculumSubject.asObservable()
    }
    
    // Cache
    var cache: YYDiskCache
    let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first

    let bag = DisposeBag()

    func prepareData(isRefresh: Bool, completionHandler: @escaping () -> Void) {
        if isRefresh {
            cache.removeObject(forKey: "Currirulum")
            curriculumModels.removeAll()
            requestCurriculum { completionHandler() }
        }else {
            if let curriculumObjects = cache.object(forKey: "Currirulum") as? [CurriculumModel], curriculumObjects.count > 0 {
                self.curriculumSubject.onNext(formatModel(curriculumModels))
                completionHandler()
            } else {
                curriculumModels.removeAll()
                requestCurriculum { completionHandler() }
            }
        }
    }

    private func requestCurriculum(completionHandler: @escaping () -> Void) {
        let provider = MoyaProvider<QueryAPI>()
        provider.request(.Curriculum(term: "17-18-3")) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                let code = json["code"].stringValue
                if code == "200" || code == "203" {
                    self.parseCurriculumModel(json)
                    self.curriculumSubject.onNext(self.formatModel(self.curriculumModels))
                    completionHandler()
                } else if code == "408"{
                    self.curriculumSubject.onError(HeraldError.NetworkError)
                }
            case .failure(_):
                self.curriculumSubject.onError(HeraldError.NetworkError)
            }
        }
    }

    private func parseCurriculumModel(_ json: JSON) {
        let curriculumArrayValue = json["result"]["curriculum"].arrayValue

        for curriculumJSON in curriculumArrayValue {
            let courseName = curriculumJSON["courseName"].stringValue
            let teacherName = curriculumJSON["teacherName"].stringValue
            let location = curriculumJSON["location"].stringValue
            let credit = curriculumJSON["credit"].intValue
            let beginWeek = curriculumJSON["beginWeek"].intValue
            let endWeek = curriculumJSON["endWeek"].intValue

            let eventArrayValue = curriculumJSON["events"].arrayValue
            var events: [EventModel] = []
            for eventJSON in eventArrayValue {
                let week = eventJSON["week"].intValue
                let startTime = eventJSON["startTime"].stringValue.substring(NSMakeRange(0, eventJSON["startTime"].stringValue.length() - 3))
                let endTime = eventJSON["endTime"].stringValue.substring(NSMakeRange(0, eventJSON["endTime"].stringValue.length() - 3))
                let event = EventModel(week, startTime, endTime)
                events.append(event)
            }
            let curriculum = CurriculumModel(courseName, credit, beginWeek, endWeek, location, teacherName, events)
            curriculumModels.append(curriculum)
        }
        cache.setObject(curriculumModels as NSCoding, forKey: "Currirulum")
    }

    private func formatModel(_ model: [CurriculumModel]) -> [[CurriculumModel]] {
        let emptyModel: [CurriculumModel] = []
        var formatModels = [[CurriculumModel]](repeating: emptyModel, count: 16)

        model.forEach { curriculum in
            curriculum.events.forEach { event in
                formatModels[event.week - 1].append(curriculum)
            }
        }
        return formatModels
    }
}
