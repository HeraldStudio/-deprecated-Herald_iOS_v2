//
//  LectureTableViewDelegate.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 19/02/2018.
//  Copyright © 2018 乔哲锋. All rights reserved.
//

import Foundation
import UIKit

extension LectureViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    

}

extension LectureViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        swiper.syncApperance()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        swiper.beginDrag()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        swiper.endDrag()
    }
}
