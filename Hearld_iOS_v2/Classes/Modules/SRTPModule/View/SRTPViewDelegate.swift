//
//  SRTPViewDelegate.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 05/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import UIKit

extension SRTPView: UITableViewDelegate {
    
}

extension SRTPView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return srtpViewModel.srtpList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SRTP", for: indexPath) as! SRTPTableViewCell
        cell.srtp = srtpViewModel.srtpList[indexPath.row]
        return cell
    }
}
