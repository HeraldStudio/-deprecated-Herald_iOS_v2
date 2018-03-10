//
//  InfoTableViewCellProtocol.swift
//  Hearld_iOS_v2
//
//  Created by 乔哲锋 on 09/03/2018.
//  Copyright © 2018 乔哲锋. All rights reserved.
//


import Foundation
import UIKit

extension InfoTableViewCell: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infoList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCollection", for: indexPath) as! InfoCollectionViewCell
        cell.nameLabel.text = self.infoList[indexPath.row].title
        cell.detailLabel.text = self.infoList[indexPath.row].detail
        return cell
    }
}

extension InfoTableViewCell: UICollectionViewDelegate {
    
}

