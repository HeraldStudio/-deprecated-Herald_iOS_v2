//
//  lectureViewDelegate.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 29/04/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import UIKit

extension LectureView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 37
    }
}

extension LectureView : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lectureViewModel.lectureModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lecture", for: indexPath) as! LectureTableViewCell
        cell.lecture = lectureViewModel.lectureModels[indexPath.row]
        return cell
    }
}
