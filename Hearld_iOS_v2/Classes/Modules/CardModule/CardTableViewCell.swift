//
//  CardTableViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 10/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {
    
    var card: CardModel? { didSet { updateUI() } }
    
    var descLabel = UILabel()
    var amountLabel = UILabel()
    var timeLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    private func customInit() {
        self.selectionStyle = .none
        layoutUI()
    }
    
    private func layoutUI() {
        descLabel.into(contentView).top(10).left(10).width(300).height(18).font(16,.semibold).color(HeraldColorHelper.NormalTextColor.Primary)
        
        amountLabel.into(contentView).below(descLabel,5).left(15).width(150).height(17).bottom(10)
            .font(15,.semibold).color(HeraldColorHelper.NormalTextColor.Primary)
        
        timeLabel.into(contentView).below(descLabel,5).right(15).width(150).height(17).bottom(10)
            .font(15,.semibold).color(HeraldColorHelper.GeneralColor.Regular).align(NSTextAlignment.right)
    }
    
    private func updateUI() {
        descLabel.text = card?.desc
        amountLabel.text = String((card?.amount)!)
        timeLabel.text = card?.time
    }
}
