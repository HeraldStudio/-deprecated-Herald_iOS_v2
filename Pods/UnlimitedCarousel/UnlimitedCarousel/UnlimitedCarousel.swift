//
//  UnlimitedCarousel.swift
//  UnlimitedCarouselDemo
//
//  Created by Nathan on 04/02/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit
import SnapKit

public struct ICIndexPath {
    public var column = 0
    public var row = 0
    init(column: Int, row: Int) {
        self.column = column
        self.row = row
    }
}

public class UnlimitedCarousel: UIView {
    
    open var intervalSecond = 4
    
    public var dataSource: UnlimitedCarouselDataSource? {
        didSet {
            numOfSection = (dataSource?.numberOfSections(in: self))!
            numOfFigures = (dataSource?.numberOfFigures(for: self))!
            customInit()
        }
    }
    public var delegate: UnlimitedCarouselDelegate?
    
    /// UI stuff
    internal let flowLayout = UICollectionViewFlowLayout()
    internal var collectionView: UICollectionView!
    internal var pageControl = UIPageControl()
    private var timer: Timer?
    
    internal var numOfSection = 3
    internal var numOfFigures = 1
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func customInit() {
        setupSubviews()
        collectionView.reloadData()
        startAutoScroll()
    }
    
    internal func setupSubviews() {
        flowLayout.itemSize = CGSize(width: frame.width, height: frame.height)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FigureCell.self, forCellWithReuseIdentifier: "Figure")
        self.addSubview(collectionView)
        /// initial position
        collectionView.scrollToItem(at: IndexPath(item: 0, section: numOfSection/2), at: .left, animated: false)
        
//        pageControl.frame = CGRect(x: self.frame.width / 2, y: self.frame.origin.y +  self.frame.height - 30, width: 20, height: 30)
        pageControl.numberOfPages = numOfFigures
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        pageControl.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        pageControl.hidesForSinglePage = true
        pageControl.isEnabled = false
        self.addSubview(pageControl)
        
        /// collectionView constraints
        collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
        }
        
        /// pageControl constraints
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(0)
            make.height.equalTo(20)
            make.width.equalTo(30)
        }
    }
    
    public func startAutoScroll() {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(intervalSecond), target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    
    @objc func autoScroll(){
        // the current indexPath
        let currentIndexPath = collectionView.indexPathsForVisibleItems.last!
        // the middle section's indexPath
        let middleIndexPath = IndexPath(item: currentIndexPath.item, section: numOfSection/2)
        // scroll to the middle section
        collectionView.scrollToItem(at: middleIndexPath, at: .left, animated: false)
        
        var nextItem = middleIndexPath.item + 1
        var nextSection = middleIndexPath.section
        if nextItem == numOfFigures {
            nextItem = 0
            nextSection += 1
        }
        collectionView.scrollToItem(at: IndexPath(item: nextItem, section: nextSection), at: .left, animated: true)
    }
    
    func endAutoScroll(){
        guard let endTimer = self.timer else{ return }
        endTimer.invalidate()
    }
}
