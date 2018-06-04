//
//  CurriculumCollectionViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 01/06/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit
import SwiftDate

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
    
    private let testLabel = UILabel()
    
    private var buttonCreator : UIButton {
        return UIButton()
    }
    
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
        testLabel.into(contentView).top(0).left(0).right(0).bottom(0).text(String(currentWeek)).background(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        
        // 周一标签
        mondayLabel.into(contentView).top(0).left(0).width(blockWidth).height(40).text("周一").font(13,.semibold).color(HeraldColorHelper.Secondary).align(.center).background(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).lines(0)
        
        // 周二标签
        tuesdayLabel.into(contentView).top(0).after(mondayLabel,0).width(blockWidth).height(40).text("周二").font(13,.semibold).color(HeraldColorHelper.Secondary).align(.center).background(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).lines(0)
        
        // 周三标签
        wednesdayLabel.into(contentView).top(0).after(tuesdayLabel,0).width(blockWidth).height(40).text("周三").font(13,.semibold).color(HeraldColorHelper.Secondary).align(.center).background(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).lines(0)
        
        // 周四标签
        thursdayLabel.into(contentView).top(0).after(wednesdayLabel,0).width(blockWidth).height(40).text("周四").font(13,.semibold).color(HeraldColorHelper.Secondary).align(.center).background(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).lines(0)
        
        // 周五标签
        fridayLabel.into(contentView).top(0).after(thursdayLabel,0).width(blockWidth).height(40).text("周五").font(13,.semibold).color(HeraldColorHelper.Secondary).align(.center).background(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)).lines(0)
    }
    
    private func updateUI() {
        testLabel.text = String(currentWeek)
        var flag = true
        curriculumList.forEach { curriculum in
            for event in curriculum.events where event.week == currentWeek {
                let timeSatmp = event.startTime.substring(NSMakeRange(0, event.startTime.length() - 3))
                let date = TimeConvertHelper.convert(from: timeSatmp)
                
                if flag {
                    let startDay = date.startWeek.add(components: 1.days)
                    updateDate(from: startDay!)
                    flag = false
                }
                
//                print(date.endWeek.weekdayName)
//                let blockFrame = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
//                let block = CurriculumBlock.init(frame: <#T##CGRect#>)
            }
        }
    }
    
    private func updateDate(from startDate: DateInRegion) {
        mondayLabel.text = TimeConvertHelper.formatDate(startDate) + "\n周一"
        tuesdayLabel.text = TimeConvertHelper.formatDate(startDate.add(components: 1.days)!) + "\n周二"
        wednesdayLabel.text = TimeConvertHelper.formatDate(startDate.add(components: 2.days)!) + "\n周三"
        thursdayLabel.text = TimeConvertHelper.formatDate(startDate.add(components: 3.days)!) + "\n周四"
        fridayLabel.text = TimeConvertHelper.formatDate(startDate.add(components: 4.days)!) + "\n周五"
    }

}
