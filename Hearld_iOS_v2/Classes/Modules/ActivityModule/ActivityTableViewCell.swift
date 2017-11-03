//
//  ActivityTableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 02/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SnapKit

class ActivityTableViewCell: UITableViewCell {
    
    var titleLabel = UILabel()
    var picture = UIImageView()
    var stateLabel = UILabel()
    var infoLabel = UILabel()
    var testImage = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubViews(subViews: [titleLabel,stateLabel,picture,infoLabel])
        layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        titleLabel.top(8).left(15).height(20)
        stateLabel.after(titleLabel, 8).right(15).centerY(titleLabel).height(16)
        picture.below(titleLabel, 16).left(15).right(15)
        infoLabel.below(picture, 12).left(15).right(15).bottom(15).height(39.5)
    }
}
