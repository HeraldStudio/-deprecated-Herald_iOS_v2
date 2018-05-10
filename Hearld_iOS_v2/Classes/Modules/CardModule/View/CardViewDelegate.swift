//
//  CardViewDelegate.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 10/05/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import UIKit

extension CardView : UITableViewDelegate {
    
}

extension CardView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardViewModel.cardModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Card", for: indexPath) as! CardTableViewCell
        cell.card = cardViewModel.cardModels[indexPath.row]
        return cell
    }
}
