//
//  CarouseFigureCellDelegate.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 19/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension CarouselFigureCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Figure", for: indexPath) as! FigureCollectionViewCell
        cell.image.contentMode = .scaleToFill
        cell.image.sd_setImage(with: URL(string: itemArray[indexPath.row].picture_url), placeholderImage: #imageLiteral(resourceName: "default_herald"))
        return cell
    }
}

extension CarouselFigureCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = itemArray[indexPath.row]
        let url = item.link
        if url != "" {
            let webVC = WebViewController()
            webVC.webUrl = URL(string: ApiHelper.changeHTTPtoHTTPS(url: url))
            webVC.navigationItem.title = item.title
            deleagte?.navigationPush(to: webVC, animated: true)
        }
    }
    
    // 手动拖动调用，无动画移动到中间section
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        CarouselFigure.scrollToItem(at: IndexPath(item: pageControl.currentPage, section: sections/2), at: .left, animated: false)
    }
    
    // 自动循环调用，无动画移动到中间section
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        CarouselFigure.scrollToItem(at: IndexPath(item: pageControl.currentPage, section: sections/2), at: .left, animated: false)
    }
    
    // 计算当前页号
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int((scrollView.contentOffset.x + (CarouselFigure.bounds.width) * 0.5) / (CarouselFigure.bounds.width))
        let currentPage = page % itemArray.count
        pageControl.currentPage = currentPage
    }
    
    // 开始拖动时暂停自动循环
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        endAutoScroll()
    }
    
    // 停止拖动时开启自动循环
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startAutoScroll()
    }
}
