//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by Mateusz Dettlaff on 27/02/2021.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var rateButtons: [UIButton]!
    @IBOutlet var closeButton: UIButton!
    
    var restaurant = Restaurant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.image = UIImage(data: restaurant.image)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
        let scaleUpTransform = CGAffineTransform.init(scaleX: 5.0, y: 5.0)
        let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform)
        
        for rateButton in rateButtons {
            rateButton.alpha = 0
            rateButton.transform = moveScaleTransform
        }
        
        let moveUpTransform = CGAffineTransform(translationX: 0, y: -600)
        closeButton.transform = moveUpTransform
        closeButton.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for rateButton in rateButtons {
            UIView.animate(withDuration: 0.4, delay: 0.1, options: [], animations: {
                rateButton.alpha = 1.0
                rateButton.transform = .identity
            }, completion: nil)
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.1, options: [], animations: {
            self.closeButton.alpha = 1.0
            self.closeButton.transform = .identity
        }, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
