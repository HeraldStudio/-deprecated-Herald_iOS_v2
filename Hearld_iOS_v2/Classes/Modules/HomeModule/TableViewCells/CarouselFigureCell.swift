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
    
    let flowLayout = UICollectionViewFlowLayout()
    var CarouselFigure: UICollectionView!
    var pageControl = UIPageControl()
    let sections = 3
    var itemArray: [CarouselFigureModel] = []
    var timer: Timer?
    var deleagte: CarouselFigureCellProtocol?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubViews()
        self.contentView.addSubViews(subViews: [CarouselFigure,pageControl])
        layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews() {
        flowLayout.itemSize = CGSize(width: screenRect.width, height: 160)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        CarouselFigure = UICollectionView(frame: self.frame, collectionViewLayout: flowLayout)
    }
    
    override func layoutSubviews() {
        contentView.background(#colorLiteral(red: 0.9003087948, green: 0.9003087948, blue: 0.9003087948, alpha: 1))
        
        CarouselFigure.left(0).right(0).top(0).bottom(0).height(160)
        CarouselFigure.showsVerticalScrollIndicator = false
        CarouselFigure.showsHorizontalScrollIndicator = false
        CarouselFigure.isPagingEnabled = true
        CarouselFigure.delegate = self
        CarouselFigure.dataSource = self
        CarouselFigure.register(FigureCollectionViewCell.self, forCellWithReuseIdentifier: "Figure")
        
        pageControl.centerX().bottom(0).height(20).width(30)
        pageControl.numberOfPages = itemArray.count
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        pageControl.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        pageControl.hidesForSinglePage = true
        pageControl.addTarget(self, action: #selector(pageChanged(_:)), for: .valueChanged)
    }
    
    func startAutoScroll() {
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    
    func autoScroll(){
        // 获取现在的indexPath
        let currentIndexPath = CarouselFigure.indexPathsForVisibleItems.last!
        // 获取中间section的indexPath
        let middleIndexPath = IndexPath(item: currentIndexPath.item, section: sections / 2)
        // 滚动到中间的Section
        CarouselFigure.scrollToItem(at: middleIndexPath, at: .left, animated: false)
        
        var nextItem = middleIndexPath.item + 1
        var nextSection = middleIndexPath.section
        if nextItem == itemArray.count {
            nextItem = 0
            nextSection += 1
        }
        CarouselFigure.scrollToItem(at: IndexPath(item: nextItem, section: nextSection), at: .left, animated: true)
    }
    
    func endAutoScroll(){
        guard let endTimer = self.timer else{ return }
        endTimer.invalidate()
    }
    
    func pageChanged(_ sender:UIPageControl){
        CarouselFigure.scrollToItem(at: IndexPath(item: pageControl.currentPage, section: sections/2), at: .left, animated: true)
    }
}

protocol CarouselFigureCellProtocol {
    func navigationPush(to vc: UIViewController, animated: Bool)
}
