//
//  RestaurantDetailHeaderView.swift
//  FoodPin
//
//  Created by Mateusz Dettlaff on 19/02/2021.
//

import UIKit

class RestaurantDetailHeaderView: UIView {
    
    @IBOutlet var restaurantNameLabel: UILabel! {
        didSet {
            restaurantNameLabel.numberOfLines = 0
            restaurantNameLabel.adjustsFontForContentSizeCategory = true
            
            if let customFont = UIFont(name: "Nunito-Bold", size: 40.0) {
                restaurantNameLabel.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: customFont)
            }
        }
    }
    @IBOutlet var restaurantTypeLabel: UILabel! {
        didSet {
            restaurantTypeLabel.numberOfLines = 0
            restaurantTypeLabel.adjustsFontForContentSizeCategory = true
            if let customFont = UIFont(name: "Nunito-Bold", size: 20.0) {
                restaurantTypeLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)
            }
        }
    }
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var heartButton: UIButton!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
