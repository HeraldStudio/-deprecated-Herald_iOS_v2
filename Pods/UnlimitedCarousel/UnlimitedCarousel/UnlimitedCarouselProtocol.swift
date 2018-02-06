//
//  UnlimitedCarouselProtocol.swift
//  UnlimitedCarouselDemo
//
//  Created by Nathan on 04/02/2018.
//  Copyright © 2018 Nathan. All rights reserved.
//

import Foundation

public protocol UnlimitedCarouselDataSource {
    
    /// number of sections in UnlimitedCarousel,
    /// the key for create Unlimited effect,
    /// 3 or 5 is recommended
    func numberOfSections(in carousel: UnlimitedCarousel) -> Int
    
    /// number of figures in UnlimitedCarousel
    func numberOfFigures(for carousel: UnlimitedCarousel) -> Int
    
    /// title for your figure
    func titleForFigure(at indexPath: ICIndexPath, in carousel: UnlimitedCarousel) -> String
    
    /// picture link url for your figure
    func picLinkForFigure(at indexPath: ICIndexPath, in carousel: UnlimitedCarousel) -> URL
}

public protocol UnlimitedCarouselDelegate {
    /// Tells the delegate that the figure at the specified index path was selected
    func didSelect(in carousel: UnlimitedCarousel, at indexPath: ICIndexPath)
}
