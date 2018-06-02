//
//  CurriculumCollectionViewCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 01/06/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit

class CurriculumCollectionViewCell: UICollectionViewCell {
    
    /* 该Cell所展示的Week */
    var currentWeek = 1
    
    var curriculumList : [CurriculumModel] = [] {
        didSet {
            updateUI()
        }
    }
    
    /* UI stuff */
    let blockWidth = screenRect.width / 5
    
    let mondayLabel = UILabel()
    let TuesdayLabel = UILabel()
    let WednesdayLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    private func customInit() {
        setUpSubviews()
    }
    
    private func setUpSubviews() {
        
    }
    
    private func updateUI() {
        
    }
}
