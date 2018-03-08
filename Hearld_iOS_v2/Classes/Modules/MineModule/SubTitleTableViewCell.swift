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
    var url: String?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    fileprivate func customInit() {
        self.contentView.addSubViews(subViews: [titleLabel,subTitleLabel])
        self.selectionStyle = .none
        layoutUI()
    }
    
    private func layoutUI() {
        titleLabel.top(8).left(8).width(100).font(16,.regular).color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        subTitleLabel.below(titleLabel,5).left(8).font(14).width(200).color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    }
}
