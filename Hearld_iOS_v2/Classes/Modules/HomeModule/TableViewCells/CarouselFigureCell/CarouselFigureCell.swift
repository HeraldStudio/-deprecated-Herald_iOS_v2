//
//  CarouselFigureCell.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 07/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SnapKit
import UnlimitedCarousel

class CarouselFigureCell: UITableViewCell {
    
    var carousel = UnlimitedCarousel()
    let sections = 3
    var itemArray: [CarouselFigureModel] = [] {
        didSet {
            carousel.dataSource = self
            carousel.delegate = self
        }
    }
    var deleagte: CarouselFigureCellProtocol?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        carousel = UnlimitedCarousel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 160))
        self.contentView.addSubview(carousel)
        layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        contentView.background(#colorLiteral(red: 0.9003087948, green: 0.9003087948, blue: 0.9003087948, alpha: 1))
    }
}

protocol CarouselFigureCellProtocol {
    func navigationPush(to vc: UIViewController, animated: Bool)
}