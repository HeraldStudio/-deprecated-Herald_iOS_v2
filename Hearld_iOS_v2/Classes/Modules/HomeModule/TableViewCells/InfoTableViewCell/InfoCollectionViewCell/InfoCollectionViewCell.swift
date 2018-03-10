//
//  InfoCollectionViewCell.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 09/03/2018.
//  Copyright © 2018 乔哲锋. All rights reserved.
//


import UIKit

class InfoCollectionViewCell: UICollectionViewCell {
    
    var nameLabel = UILabel()
    var detailLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    fileprivate func customInit() {
        self.contentView.addSubViews(subViews: [nameLabel,detailLabel])
        layoutUI()
    }
    
    private func layoutUI() {
        nameLabel.centerX().top(5).height(16).width(self.frame.width - 10)
            .font(15, .semibold).color(#colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)).align(.center)
        detailLabel.below(nameLabel, 10).centerX().width(self.frame.width - 10).height(16)
            .font(15,.semibold).color(#colorLiteral(red: 0.137254902, green: 0.4784313725, blue: 0.5254901961, alpha: 1)).bottom(5).align(.center)
    }
}

