//
//  MovieDetailViewController.swift
//  DGV
//
//  Created by DaHae Kim on 2021/12/08.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    @IBOutlet weak var posterImg: UIImageView!
    
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    
    var selectedTitle: String?
    var selectedRating: String?
    var selectedDirector: String?
    var selectActor: String?
    var selectPosterImg: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedTitle = selectedTitle {
            titleNavigationItem.title = selectedTitle
        }
        
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        titleLabel.text = selectedTitle
        ratingLabel.text = selectedRating
        directorLabel.text = selectedDirector
        actorLabel.text = selectActor
        
    }

}
