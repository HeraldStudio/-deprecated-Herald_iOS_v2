//
//  CarouselFigureViewModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 08/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON
import Alamofire
import RealmSwift

struct CarouselFigureViewModel {
    var model: [CarouselFigureModel] = []
    
    fileprivate let CarouselFigureSubject = PublishSubject<[CarouselFigureModel]>()
    var CarouselFigures: Observable<[CarouselFigureModel]>{
        return CarouselFigureSubject.asObservable()
    }
    let bag = DisposeBag()
    
    func prepareData() {
        
    }
}
