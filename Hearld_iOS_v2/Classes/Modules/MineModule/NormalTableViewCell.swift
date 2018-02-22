//
//  NormalTableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 06/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SnapKit

class NormalTableViewCell: UITableViewCell {
    var normalLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(normalLabel)
        self.selectionStyle = .none
        layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        normalLabel.centerY().left(8).font(16,.regular).color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
}
