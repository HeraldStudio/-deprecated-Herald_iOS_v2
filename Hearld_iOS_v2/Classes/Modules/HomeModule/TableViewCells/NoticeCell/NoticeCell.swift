//
//  NoticeCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 22/04/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit

class NoticeCell: UITableViewCell {
    
    var notice : NoticeModel? { didSet { updateUI() } }
    
    // UI stuff
    let titleLabel = UILabel()
    let categoryLabel = UILabel()
    var timeLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    fileprivate func customInit() {
        setupSubViews()
    }
    
    private func setupSubViews() {
        
        titleLabel.into(contentView).top(10).left(10).right(10).lines(0).font(16,.semibold).color(#colorLiteral(red: 0.03326239809, green: 0.6802185178, blue: 0.7709155083, alpha: 1))
        
        categoryLabel.into(contentView).below(titleLabel,5).left(10).bottom(8).width(180).height(30).font(16,.semibold).color(#colorLiteral(red: 0.3330089152, green: 0.333286792, blue: 0.3330519199, alpha: 1))
        
        timeLabel.into(contentView).below(titleLabel,5).after(categoryLabel, 80).right(10).bottom(8).height(30).font(16,.semibold).color(#colorLiteral(red: 0.8132867217, green: 0.8139086962, blue: 0.8133830428, alpha: 1)).text("发布于")
    }
    
    private func updateUI() {
        titleLabel.text = notice?.title
        categoryLabel.text = notice?.category
        timeLabel.text = timeLabel.text! + " " + (notice?.displayTime)!
    }
    
}
