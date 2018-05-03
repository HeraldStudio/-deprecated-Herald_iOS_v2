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
        
        titleLabel.into(contentView).top(10).left(10).right(10).lines(0).font(16,.semibold).color(HeraldColorHelper.Primary)
        
        categoryLabel.into(contentView).below(titleLabel,5).left(10).bottom(8).width(180).height(30).font(16,.semibold).color(HeraldColorHelper.Bold)
        
        timeLabel.into(contentView).below(titleLabel,5).after(categoryLabel, 60).right(10).bottom(8).height(30).font(16,.semibold).color(HeraldColorHelper.Secondary).text("发布于")
    }
    
    private func updateUI() {
        titleLabel.text = notice?.title
        categoryLabel.text = notice?.category
        timeLabel.text = timeLabel.text! + " " + (notice?.displayTime)!
    }
    
}
