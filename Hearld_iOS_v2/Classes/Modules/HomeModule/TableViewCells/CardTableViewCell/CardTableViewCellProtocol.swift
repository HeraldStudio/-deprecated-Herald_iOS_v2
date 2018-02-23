//
//  CardTableViewCellProtocol.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 23/02/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation
import UIKit

extension CardTableViewCell: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollection", for: indexPath) as! CardCollectionViewCell
        cell.image.image = UIImage(named: self.cardList[indexPath.row].icon)
        cell.textLabel.text = self.cardList[indexPath.row].name
        return cell
    }
}

extension CardTableViewCell: UICollectionViewDelegate {
    
}
