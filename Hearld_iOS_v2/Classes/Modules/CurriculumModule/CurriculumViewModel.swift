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

typealias curriculumItem = [CurriculumModel]

class CurriculumViewModel {

    /* 单例 */
    static let shared = CurriculumViewModel()

    private init() {}

    /* Model */
    var curriculumModels : [CurriculumModel] = []
    var eventModels : [EventModel] = []

    /* Subject */
    fileprivate let curriculumSubject = PublishSubject<[curriculumItem]>()
    var curriculumTable: Observable<[curriculumItem]> {
        return curriculumSubject.asObservable()
    }

    let bag = DisposeBag()

    func prepareData(isRefresh: Bool, completionHandler: @escaping ()->()) {
        guard let realm = try? Realm() else {
            return
        }
        if isRefresh {
            let results = realm.objects(CurriculumModel.self)
            db_deleteObjcs(results, with: realm)
            curriculumModels.removeAll()
            requestCurriculum { completionHandler() }
        }else {
            let CurriculumObjects = realm.objects(CurriculumModel.self)
            if !CurriculumObjects.isEmpty {
                self.curriculumSubject.onNext(formatModel(curriculumModels))
                completionHandler()
            } else {
                curriculumModels.removeAll()
                requestCurriculum { completionHandler() }
            }
        }
    }

    private func requestCurriculum(completionHandler: @escaping ()->()) {
        let provider = MoyaProvider<QueryAPI>()
        provider.request(.Curriculum(term: "17-18-3")) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                print(json)
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
            let curriculum = CurriculumModel()
            curriculum.courseName = curriculumJSON["courseName"].stringValue
            curriculum.teacherName = curriculumJSON["teacherName"].stringValue
            curriculum.location = curriculumJSON["location"].stringValue
            curriculum.credit = curriculumJSON["credit"].intValue
            curriculum.beginWeek = curriculumJSON["beginWeek"].intValue
            curriculum.endWeek = curriculumJSON["endWeek"].intValue

            let eventArrayValue = curriculumJSON["events"].arrayValue
            for eventJSON in eventArrayValue {
                let event = EventModel()
                event.week = eventJSON["week"].intValue
                event.startTime = eventJSON["startTime"].stringValue
                event.endTime = eventJSON["endTime"].stringValue
                curriculum.events.append(event)
            }

            // 添加入数据库
            db_addObjc(curriculum, with: realm)
            curriculumModels.append(curriculum)
        }
    }

    private func formatModel(_ model : [CurriculumModel]) -> [[CurriculumModel]] {
        let emptyModel : [CurriculumModel] = []
        var formatModels = [[CurriculumModel]](repeating: emptyModel, count: 16)

        model.forEach { curriculum in
            curriculum.events.forEach { event in
                formatModels[event.week - 1].append(curriculum)
            }
        }
        return formatModels
    }
}
