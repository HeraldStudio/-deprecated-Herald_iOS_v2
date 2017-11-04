//
//  SubTitleTableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 04/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SnapKit

class SubTitleTableViewCell: UITableViewCell {
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubViews(subViews: [titleLabel,subTitleLabel])
        layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        titleLabel.top(8).left(8)
        subTitleLabel.below(titleLabel,5).left(8)
    }
}
