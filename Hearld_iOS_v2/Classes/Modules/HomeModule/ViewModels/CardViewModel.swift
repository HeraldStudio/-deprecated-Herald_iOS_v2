//
//  CardViewModel.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 23/02/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CardViewModel {
    var model: [CardModel] = []
    
    fileprivate let CardSubject = PublishSubject<[CardModel]>()
    var Cards: Observable<[CardModel]>{
        return CardSubject.asObservable()
    }
    let bag = DisposeBag()
    
    func prepareData() {
        model.removeAll()
        model.append(CardModel("一卡通","ic_card_invert"))
        model.append(CardModel("人文讲座","ic_lecture_invert"))
        model.append(CardModel("课外研学","ic_srtp_invert"))
        model.append(CardModel("教务通知","ic_jwc_invert"))
        self.CardSubject.onNext(model)
    }
}
