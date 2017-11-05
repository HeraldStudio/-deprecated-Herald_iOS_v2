//
//  ActivityTableViewDelegate.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 03/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import UIKit

extension ActivityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
}

extension ActivityViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        swiper.syncApperance()
        puller.syncApperance()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        swiper.beginDrag()
        puller.beginDrag()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        swiper.endDrag()
        puller.endDrag()
    }
}
