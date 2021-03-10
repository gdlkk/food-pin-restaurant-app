//
//  AboutTableViewController.swift
//  FoodPin
//
//  Created by Mateusz Dettlaff on 10/03/2021.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {
    
    enum Section {
        case feedback
        case followus
        case twitter
        case facebook
        case instagram
    }
    
    struct LinkItem: Hashable {
        var text: String
        var link: String
        var image: String
    }
    
    lazy var dataSource = configureDataSource()
    
    var sectionContent = [
        [LinkItem(text: "Rate us on App Stoe", link: "https://www.apple.com/ios/app-store/", image: "store")],
        [LinkItem(text: "Tell us your feedback", link: "https://media1.tenor.com/images/467d353f7e2d43563ce13fddbb213709/tenor.gif?itemid=12136175", image: "chat")],
        [LinkItem(text: "Facebook", link: "https://facebook.com", image: "facebook")],
        [LinkItem(text: "Instagram", link: "https://instagram.com/gdlk_", image: "instagram")],
        [LinkItem(text: "Twitter", link: "https://twitter.com", image: "twitter")]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if let appearanace = navigationController?.navigationBar.standardAppearance {
            appearanace.configureWithTransparentBackground()
            
            if let customFont = UIFont(name: "Nunito-Bold", size: 45.0) {
                appearanace.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
                appearanace.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
                
                navigationController?.navigationBar.standardAppearance = appearanace
                navigationController?.navigationBar.compactAppearance = appearanace
                navigationController?.navigationBar.scrollEdgeAppearance = appearanace
            }
        }

        tableView.dataSource = dataSource
        updateSnapshot()
    }
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section, LinkItem> {
        let cellIdentifier = "aboutcell"
        
        let dataSource = UITableViewDiffableDataSource<Section, LinkItem>(tableView: tableView) { (tableView, indexPath, linkItem) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            cell.textLabel?.text = linkItem.text
            cell.imageView?.image = UIImage(named: linkItem.image)
            
            return cell
        }
        return dataSource
    }
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, LinkItem>()
        snapshot.appendSections([.feedback, .followus])
        snapshot.appendItems(sectionContent[0], toSection: .feedback)
        snapshot.appendItems(sectionContent[1], toSection: .feedback)
        snapshot.appendItems(sectionContent[2], toSection: .followus)
        snapshot.appendItems(sectionContent[3], toSection: .followus)
        snapshot.appendItems(sectionContent[4], toSection: .followus)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            openWithSafariViewController(indexPath: indexPath)
        case 1:
            openWithSafariViewController(indexPath: indexPath)
        case 2:
            openWithSafariViewController(indexPath: indexPath)
        case 3:
            openWithSafariViewController(indexPath: indexPath)
        case 4:
            openWithSafariViewController(indexPath: indexPath)
        default:
            break
            
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func openWithSafariViewController(indexPath: IndexPath) {
        guard let linkItem = self.dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        if let url = URL(string: linkItem.link) {
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true, completion: nil)
        }
    }

}
