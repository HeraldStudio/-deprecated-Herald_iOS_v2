//
//  PullLoadFooter.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 04/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// 一个简单的上拉加载控件。使用该控件要注意以下几点（尤其最后四条）
//- 0、父控件是 UIScrollView 或其子类，如 UITableView
//- 1、本控件要放在最底部，例如可以作为 UITableView 的 tableFooterView 使用
/// 2、将本控件添加到父控件前，要先设置 loader
/// 3、在父控件 scrollViewDidScroll 代理方法中要调用 syncApperance(_:)，参数是父控件的 contentOffset.y
/// 4、在父控件 scrollViewDidBeginDragging 代理方法中要调用 beginDrag()
/// 5、在父控件 scrollViewDidEndDragging 代理方法中要调用 endDrag()

class PullLoadFooter : UIView {
    
    /// 背景不透明度从0淡入到1的距离。若 contentView 留空，则始终不透明，不会淡入淡出
    let fadeDistance : CGFloat = 150
    
    /// 触发加载的最小滑动距离
    let loadDistance : CGFloat = 48
    
    /// 加载提示文本
    let load = UILabel()
    
    /// 加载触发的事件
//    var loader : (() -> Void)?
    var isEvent = Variable<Bool>(false)
    
    /// 上拉加载控件没有拉伸时的原始高度
    var realHeight = CGFloat(0)
    
    /// 视图被展示时的操作
    override func didMoveToSuperview() {
        
        // 先移除所有子视图，以防万一
        removeAllSubviews()
        
        // 计算原始高度
        realHeight = self.frame.height
        
        // 计算尺寸
        self.frame = CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.width)!, height: realHeight)
        
        // 添加加载提示文字
        load.frame = self.frame
        load.textColor = UIColor.lightGray
        load.textAlignment = .center
        load.font = UIFont.systemFont(ofSize: 14)
        load.clipsToBounds = true
        addSubview(load)
        
        // 首次重绘
        syncApperance()
    }
    
    /// 重绘
    func syncApperance () {
        // 如果列表内容高度不足一屏，先加一个空白视图补足一屏
        let topPadding = max(0, (superview?.frame.height)! - (superview! as! UIScrollView).contentSize.height)
        
        // 计算高度（不含 topPadding）
        let height = max((superview?.frame.height)! + (superview! as! UIScrollView).contentOffset.y - (superview! as! UIScrollView).contentSize.height - topPadding, 0)
        
        // 设置提示文字
        if enabled {
            load.text = height >= loadDistance && dragging ? "松手加载" : "上拉加载"
        }
        
        // 设置透明度和区域
        load.alpha = min(height / max(16, realHeight), 1)
        load.frame = CGRect(x: 0, y: topPadding, width: frame.width, height: height)
    }
    
    /// 记录是否正在拖动，说明见 SwipeRefreshHeader
    var dragging = false
    
    /// 记录拖动开始，需要在父视图代理中调用
    func beginDrag () {
        dragging = true
    }
    
    /// 记录拖动结束，需要在父视图代理中调用
    func endDrag () {
        dragging = false
        guard let text = load.text else { return }
        if text == "松手加载" && enabled {
//            loader?()
            isEvent.value = true
        }
        isEvent.value = false
    }
    
    /// 是否启用上拉加载
    var enabled = true
    
    /// 立即启用上拉加载
    func enable() {
        enabled = true
    }
    
    /// 立即禁用上拉加载，并显示一段提示文字
    func disable(_ placeholder : String) {
        enabled = false
        load.text = placeholder
    }
}

