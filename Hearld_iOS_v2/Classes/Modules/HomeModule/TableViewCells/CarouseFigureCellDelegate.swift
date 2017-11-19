//
//  CarouseFigureCellDelegate.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 19/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import UIKit

extension CarouselFigureCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("滑动结束后的contentOffset")
//        print(CarouselFigure.contentOffset.x)
        if(CarouselFigure.contentOffset.x == 0){
            CarouselFigure.contentOffset.x = (pictureFrame?.size.width)! * CGFloat(itemArray.count)
        }
        if(CarouselFigure.contentOffset.x == (pictureFrame?.size.width)! * CGFloat(itemArray.count + 1)){
//            print("focus contentOffset")
//            print(CarouselFigure.contentOffset.x)
            CarouselFigure.contentOffset.x = (pictureFrame?.size.width)!
        }
        let page = Int(CarouselFigure.contentOffset.x / (pictureFrame?.size.width)!) - 1
        pageControl.currentPage = page
    }
    
    // 自动循环调用
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if(CarouselFigure.contentOffset.x == 0){
            CarouselFigure.contentOffset.x = (pictureFrame?.size.width)! * CGFloat(itemArray.count)
        }
        if(CarouselFigure.contentOffset.x == (pictureFrame?.size.width)! * CGFloat(itemArray.count + 1)){
            CarouselFigure.contentOffset.x = (pictureFrame?.size.width)!
        }
        let page = Int(CarouselFigure.contentOffset.x / (pictureFrame?.size.width)!) - 1
        pageControl.currentPage = page
    }
    
    // 开始拖动时暂停自动循环
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        endAutoScroll()
    }
    
    // 停止拖动时开启自动循环
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startAutoScroll()
    }
}
