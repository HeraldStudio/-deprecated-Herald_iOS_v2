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
        let page = Int(CarouselFigure.contentOffset.x / CarouselFigure.frame.size.width)
        pageControl.currentPage = page
    }
}
