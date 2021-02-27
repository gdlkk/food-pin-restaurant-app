//
//  NavigationController.swift
//  FoodPin
//
//  Created by Mateusz Dettlaff on 20/02/2021.
//

import UIKit

class NavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
