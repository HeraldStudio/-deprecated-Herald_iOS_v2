//
//  CardCollectionViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 23/02/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    var image = UIImageView()
    var textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    fileprivate func customInit() {
        self.contentView.addSubViews(subViews: [image,textLabel])
        layoutUI()
    }
    
    private func layoutUI() {
        image.left(5).top(5).bottom(5).height(self.frame.height - 10).width(self.frame.height - 10)
        textLabel.after(image,5).top(5).bottom(5).width(60).height(self.frame.height - 10).font(13,.regular)
    }
}
