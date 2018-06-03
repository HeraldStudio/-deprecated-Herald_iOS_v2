//
//  CurriculumCollectionViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 01/06/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit

class CurriculumCollectionViewCell: UICollectionViewCell {
    
    /* 该Cell所展示的Week */
    var currentWeek = 1
    
    var curriculumList : [CurriculumModel] = [] {
        didSet {
            updateUI()
        }
    }
    
    /* UI stuff */
    private let blockWidth = screenRect.width / 5
    
    private let mondayLabel = UILabel()
    private let tuesdayLabel = UILabel()
    private let wednesdayLabel = UILabel()
    private let thursdayLabel = UILabel()
    private let fridayLabel = UILabel()
    private let saturdayLabel = UILabel()
    private let sundayLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    private func customInit() {
        setUpSubviews()
    }
    
    private func setUpSubviews() {
        // 周一标签
        mondayLabel.into(contentView).top(0).left(0).width(blockWidth).height(40).text("一").font(16,.semibold).align(.center)
        
        // 周二标签
        tuesdayLabel.into(contentView).top(0).after(mondayLabel,0).width(blockWidth).height(40).text("二").font(16,.semibold).align(.center)
        
        // 周三标签
        wednesdayLabel.into(contentView).top(0).after(tuesdayLabel,0).width(blockWidth).height(40).text("三").font(16,.semibold).align(.center)
        
        // 周四标签
        thursdayLabel.into(contentView).top(0).after(wednesdayLabel,0).width(blockWidth).height(40).text("四").font(16,.semibold).align(.center)
        
        // 周五标签
        fridayLabel.into(contentView).top(0).after(thursdayLabel,0).width(blockWidth).height(40).text("五").font(16,.semibold).align(.center)
    }
    
    private func updateUI() {
        
    }
}
