//
//  CarouselFigureCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 07/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SnapKit

class CarouselFigureCell: UITableViewCell {
    
    var CarouselFigure = UIScrollView()
    var pageControl = UIPageControl()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        CarouselFigure.addSubview(pageControl)
        contentView.addSubViews(subViews: [CarouselFigure])
        layoutSubviews()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        CarouselFigure.left(0).right(0).top(0).bottom(0).height(160)
        
        pageControl.centerX().bottom(5).height(20).width(30)
        pageControl.currentPageIndicatorTintColor = UIColor.blue
    }
}
