//
//  RestaurantDiffableDataSource.swift
//  FoodPin
//
//  Created by Mateusz Dettlaff on 18/02/2021.
//

import UIKit

enum Section {
    case all
}

class RestaurantDiffableDataSource: UITableViewDiffableDataSource<Section, Restaurant> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
