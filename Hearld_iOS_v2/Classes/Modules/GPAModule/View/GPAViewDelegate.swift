//
//  GPAViewDelegate.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 07/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import UIKit

extension GPAView : UITableViewDelegate {
    
}

extension GPAView : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gpaViewModel.gpaModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gpa", for: indexPath) as! GPATableViewCell
        cell.gpa = gpaViewModel.gpaModels[indexPath.row]
        return cell
    }
}
