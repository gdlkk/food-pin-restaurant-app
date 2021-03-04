//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Mateusz Dettlaff on 02/02/2021.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController {
    
    var restaurants: [Restaurant] = []
    var fetchResultController: NSFetchedResultsController<Restaurant>!
    
    lazy var dataSource = configureDataSource()
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet var emptyRestaurantView: UIView!
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRestaurantData()
        
        tableView.backgroundView = emptyRestaurantView
        tableView.backgroundView?.isHidden = restaurants.count == 0 ? false : true
        
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        if let appearance = navigationController?.navigationBar.standardAppearance {
            appearance.configureWithTransparentBackground()
            
            if let customFont = UIFont(name: "Nunito-Bold", size: 45.0) {
                appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
            }
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        navigationItem.backButtonTitle = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func updateSnapshot(animatingChange: Bool = false) {
        if let fetchedObjects = fetchResultController.fetchedObjects {
            restaurants = fetchedObjects
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
        
        tableView.backgroundView?.isHidden = restaurants.count == 0 ? false : true
    }
    
    func fetchRestaurantData() {
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                updateSnapshot()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - UITableView Diffable Data Source
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section, Restaurant> {
        let cellIdentifier = "datacell"
        let dataSource = RestaurantDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, restaurant in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
                
                cell.nameLabel.text = restaurant.name
                cell.locationLabel.text = restaurant.location
                cell.typeLabel.text = restaurant.type
                cell.thumbnailImageView.image = UIImage(data: restaurant.image)
                cell.heartImageView.isHidden = restaurant.isFavorite ? false : true
                
                return cell
            })
        return dataSource
    }
    
    // MARK: - UITableView Protocol
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let optionMenu = UIAlertController(title: nil, message: "What do you want todo?", preferredStyle: .actionSheet)
//        if let popoverController = optionMenu.popoverPresentationController {
//            if let cell = tableView.cellForRow(at: indexPath) {
//                popoverController.sourceView = cell
//                popoverController.sourceRect = cell.bounds
//            }
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        optionMenu.addAction(cancelAction)
//
//        let reserveActionHandler = { (action: UIAlertAction!) -> Void in
//            let alertMessage = UIAlertController(title: "Not avaliable yet", message: "Sorry, this feature is not avaliable yey. Please retry later", preferredStyle: .alert)
//
//            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alertMessage, animated: true, completion: nil)
//        }
//
//        let reserveAction = UIAlertAction(title: "Reserve a table", style: .default, handler: reserveActionHandler)
//        optionMenu.addAction(reserveAction)
//
//        let favoriteNotFavorite = self.restaurants[indexPath.row].isFavorite ? "Remove from favorites" : "Mark as favorite"
//        let favoriteAction = UIAlertAction(title: favoriteNotFavorite, style: .default, handler: { (action:UIAlertAction!)  -> Void in
//
//            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
//
//            cell.heartImageView.isHidden = self.restaurants[indexPath.row].isFavorite
//            self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false : true
//        })
//        optionMenu.addAction(favoriteAction)
//
//        present(optionMenu, animated: true, completion: nil)
//
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
    
    // MARK: - UISwipeAction Configuration
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            guard let restaurant = self.dataSource.itemIdentifier(for: indexPath)
            else {
                return UISwipeActionsConfiguration()
            }
            
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    let context = appDelegate.persistentContainer.viewContext
                    
                    context.delete(restaurant)
                    appDelegate.saveContext()
                    
                    self.updateSnapshot(animatingChange: true)
                }
                
                completionHandler(true)
            }
        deleteAction.backgroundColor = UIColor.systemRed
        deleteAction.image = UIImage(systemName: "trash")
            
            let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
                let defaultText = "Just checking in at " + restaurant.name
                let activityController: UIActivityViewController
                
                if let imageToShare = UIImage(data: restaurant.image) {
                    activityController = UIActivityViewController(activityItems: [defaultText,imageToShare], applicationActivities: nil)
                } else {
                    activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
                }
                
                if let popoverController = activityController.popoverPresentationController {
                    if let cell = tableView.cellForRow(at: indexPath) {
                        popoverController.sourceView = cell
                        popoverController.sourceRect = cell.bounds
                    }
                }
                
                self.present(activityController, animated: true, completion: nil)
                completionHandler(true)
            }
        shareAction.backgroundColor = UIColor.systemOrange
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        return swipeConfiguration
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favoriteAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
            
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
            
            cell.heartImageView.isHidden = self.restaurants[indexPath.row].isFavorite
            self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false : true
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                appDelegate.saveContext()
            }
            completionHandler(true)
        }
        favoriteAction.backgroundColor = UIColor.systemYellow
        favoriteAction.image = self.restaurants[indexPath.row].isFavorite ? UIImage(systemName: "heart.slash.fill") : UIImage(systemName: "heart.fill")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [favoriteAction])

        return swipeConfiguration
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController =  segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = self.restaurants[indexPath.row]
            }
        }
    }
}

extension RestaurantTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot()
    }
}
