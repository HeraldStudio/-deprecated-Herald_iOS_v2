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
        let provider = MoyaProvider<SubscribeAPI>()
        
        provider.request(.CarouselFigure()) { (result) in
            var figures : [CarouselFigureModel] = []
            switch result{
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                figures = self.parseCarouselFigureModel(json)
                self.CarouselFigureSubject.onNext(figures)
            case .failure(_):
                self.CarouselFigureSubject.onError(HeraldError.NetworkError)
            }
        }
    }
    
    private func parseCarouselFigureModel(_ json: JSON) -> [CarouselFigureModel] {
        var figureArray : [CarouselFigureModel] = []
        let figures = json["content"]["sliderviews"].arrayValue
        for figureJSON in figures{
            let figure = CarouselFigureModel()
            figure.title = figureJSON["title"].stringValue
            figure.picture_url = figureJSON["imageurl"].stringValue
            figure.link = figureJSON["url"].stringValue
            figureArray.append(figure)
        }
        /* 测试使用 */
//        let figure = CarouselFigureModel()
//        figure.title = "一鸣惊人"
//        figure.picture_url = "http://static.myseu.cn/2017-11-15-%E5%B0%8F%E7%8C%B4-2-.jpg"
//        figure.link = "https://myseu.cn/counter/%E8%BD%AE%E6%92%AD%E5%9B%BE%EF%BC%9A%E8"
//        figureArray.append(figure)
//        figureArray.append(figure)
//        figureArray.append(figure)
//        figureArray.append(figure)
//        figureArray.append(figure)
        return figureArray
    }
}
