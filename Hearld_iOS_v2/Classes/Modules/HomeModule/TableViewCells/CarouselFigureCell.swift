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
        self.contentView.addSubViews(subViews: [CarouselFigure,pageControl])
        layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        contentView.background(#colorLiteral(red: 0.9003087948, green: 0.9003087948, blue: 0.9003087948, alpha: 1))
        
        CarouselFigure.frame = CGRect(x: 0, y: 0, width: screenRect.width, height: 160)
        CarouselFigure.left(0).right(0).top(0).bottom(0).height(160)
        CarouselFigure.showsVerticalScrollIndicator = false
        CarouselFigure.showsHorizontalScrollIndicator = false
        CarouselFigure.isPagingEnabled = true
        CarouselFigure.delegate = self
        
        pageControl.centerX().bottom(5).height(20).width(30)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        pageControl.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        pageControl.hidesForSinglePage = true
        pageControl.addTarget(self, action: #selector(pageChanged(_:)), for: .valueChanged)
    }
    
    func pageChanged(_ sender:UIPageControl){
        var frame = CarouselFigure.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        CarouselFigure.scrollRectToVisible(frame, animated: true)
    }
}
