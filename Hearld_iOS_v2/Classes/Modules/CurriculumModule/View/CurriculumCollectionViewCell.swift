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
    private let blockWidth : CGFloat = screenRect.width / 5
    private let blockHeight : CGFloat = 40.0
    
    private let mondayLabel = UILabel()
    private let tuesdayLabel = UILabel()
    private let wednesdayLabel = UILabel()
    private let thursdayLabel = UILabel()
    private let fridayLabel = UILabel()
    private let saturdayLabel = UILabel()
    private let sundayLabel = UILabel()
    
    /* 课程开始时间所对饮的block起始位置 */
    let hour2blcokTable : Dictionary<Int,CGFloat> = [ 8 * 60       : (40.0 * 0), // 8点开始的课程
                                                      8 * 60 + 50  : (40.0 * 1), // 8点50开始的课程
                                                      9 * 60 + 50  : (40.0 * 2), // 9点50开始的课程
                                                      10 * 60 + 40 : (40.0 * 3), // 10点40开始的课程
                                                      11 * 60 + 30 : (40.0 * 4), // 11点30开始的课程
                                                      14 * 60      : (40.0 * 5), // 14点开始的课程
                                                      14 * 60 + 50 : (40.0 * 6), // 14点50开始的课程
                                                      15 * 60 + 50 : (40.0 * 7), // 15点50开始的课程
                                                      16 * 60 + 40 : (40.0 * 8), // 16点40开始的课程
                                                      17 * 60 + 30 : (40.0 * 9), // 17点30开始的课程
                                                      18 * 60 + 30 : (40.0 * 10),// 18点30开始的课程
                                                      19 * 60 + 20 : (40.0 * 11),// 19点20开始的课程
                                                      20 * 60 + 10 : (40.0 * 12)]// 20点10开始的课程
    
    
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
        var flag = true
        curriculumList.forEach { curriculum in
            for event in curriculum.events where event.week == currentWeek {
                /* 更新日期，仅执行一次 */
                if flag {
                    let timeStamp = TimeConvertHelper.convert(from: event.startTime)
                    let startDay = timeStamp.startWeek.add(components: 1.days)
                    updateDate(from: startDay)
                    flag = false
                }
                
                let startTime = TimeConvertHelper.convert(from: event.startTime)
                let endTime = TimeConvertHelper.convert(from: event.endTime)
                
                // 先不考虑周末的课程
                if (startTime.weekday - 1) > 5 {
                    continue
                }
                
                let weekDay = startTime.weekday - 1
                let durationHour = (endTime - startTime).in(.minute)
                let numbers = numberOfBlock(duration: durationHour!)
                let timeInterval = startTime.hour * 60 + startTime.minute
                
                let blockFrame = CGRect(x: CGFloat(weekDay - 1) * blockWidth,
                                        y: CGFloat(40) + hour2blcokTable[timeInterval]!,
                                        width: blockWidth,
                                        height: CGFloat(40 * numbers))
                let block = CurriculumBlock.init(frame: blockFrame)
                block.setText(course: curriculum.courseName,
                              teacherName: curriculum.teacherName,
                              location: curriculum.location)
                block.into(contentView)
            }
        }
    }
    
    private func updateDate(from startDate: Date) {
        mondayLabel.text = TimeConvertHelper.formatDate(startDate) + "\n周一"
        tuesdayLabel.text = TimeConvertHelper.formatDate(startDate.add(components: 1.days)) + "\n周二"
        wednesdayLabel.text = TimeConvertHelper.formatDate(startDate.add(components: 2.days)) + "\n周三"
        thursdayLabel.text = TimeConvertHelper.formatDate(startDate.add(components: 3.days)) + "\n周四"
        fridayLabel.text = TimeConvertHelper.formatDate(startDate.add(components: 4.days)) + "\n周五"
    }
}

// MARK: 课程表时间转换相关
extension CurriculumCollectionViewCell {
    fileprivate func numberOfBlock(duration minute : Int) -> CGFloat{
        switch minute {
        // 两节课
        case 95:
            return 2
        // 白天三节课
        case 155:
            return 3
        // 晚上三节课
        case 145:
            return 3
        // 四节课
        case 205:
            return 4
        // 还能有上一节的课嘛！
        default:
            return 1
        }
    }
}
