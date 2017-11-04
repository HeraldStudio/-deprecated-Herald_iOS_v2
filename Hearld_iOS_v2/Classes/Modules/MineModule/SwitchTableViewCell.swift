//
//  SwitchTableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 04/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SnapKit

class SwitchTableViewCell: UITableViewCell {
    var wordLabel = UILabel()
    var switchh = UISwitch()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubViews(subViews: [wordLabel,switchh])
        layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        wordLabel.top(8).left(8).bottom(8)
        switchh.right(8).centerY(wordLabel)
    }
}
