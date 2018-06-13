//
//  InfoViewModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 01/04/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//


import Foundation
import RxSwift
import RxCocoa

class InfoViewModel {
    var model: [infoItem] = []
    
    fileprivate let infoSubject = PublishSubject<[infoItem]>()
    var Info: Observable<[infoItem]>{
        return infoSubject.asObservable()
    }
    let bag = DisposeBag()
    
    func prepareData() {
        model.removeAll()
        model.append(infoItem.cardExtra)
        model.append(infoItem.grade)
        model.append(infoItem.lecture)
        model.append(infoItem.pe)
        model.append(infoItem.srtp)
        infoSubject.onNext(model)
    }
}

