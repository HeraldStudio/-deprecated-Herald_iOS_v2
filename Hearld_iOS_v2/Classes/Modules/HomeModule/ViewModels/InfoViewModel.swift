//
//  InfoViewModel.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 09/03/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//


import Foundation
import RxSwift
import RxCocoa

class InfoViewModel {
    var model: [InfoModel] = []
    
    fileprivate let InfoSubject = PublishSubject<[InfoModel]>()
    var Info: Observable<[InfoModel]>{
        return InfoSubject.asObservable()
    }
    let bag = DisposeBag()
    
    func prepareData() {
        model.removeAll()
        model.append(InfoModel("一卡通余额","135.5"))
        model.append(InfoModel("人文讲座","6"))
        model.append(InfoModel("课外研学","5.5"))
        model.append(InfoModel("首修绩点","4.0"))
        self.InfoSubject.onNext(model)
    }
}

