//
//  FigureCollectionViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 02/02/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit

class FigureCollectionViewCell: UICollectionViewCell {
    
    var image = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(image)
        layoutSubviews()
    }
    
    override required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        image.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        image.top(0).left(0).right(0).bottom(0)
    }
}
