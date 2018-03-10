//
//  InfoTableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 09/03/2018.
//  Copyright © 2018 乔哲锋. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    var infoList: [InfoModel] = []
    
    internal let flowLayout = UICollectionViewFlowLayout()
    internal var collectionView: UICollectionView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    fileprivate func customInit() {
        setupSubviews()
    }
    
    internal func setupSubviews() {
        flowLayout.itemSize = CGSize(width: screenRect.width/4, height: 52)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: self.frame, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: "InfoCollection")
        self.contentView.addSubview(collectionView)
        
        /// collectionView constraints
        collectionView.top(0).left(0).right(0).bottom(0).background(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    }
}

