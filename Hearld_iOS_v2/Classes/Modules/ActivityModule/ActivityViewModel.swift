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
        
    }
    
    private func requestActivities() {
        
    }
}
