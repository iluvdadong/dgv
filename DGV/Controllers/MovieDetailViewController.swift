//
//  MovieDetailViewController.swift
//  DGV
//
//  Created by DaHae Kim on 2021/12/08.
//

import UIKit
import WebKit

class MovieDetailViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    @IBOutlet weak var posterImg: UIImageView!
    
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    
    @IBOutlet weak var movieWebView: WKWebView!
    
    var selectedTitle: String?
    var selectedRating: String?
    var selectedDirector: String?
    var selectedActor: String?
    var selectedPosterImg: String?
    var selectedLink: String?
    var selectedImgURL: String?
    
    override func loadView() {
        super.loadView()
        
        movieWebView.uiDelegate = self
        movieWebView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let title = selectedTitle {
            titleNavigationItem.title = title
        }
        let url = URL(string: selectedLink ?? "https://movie.naver.com/")
              let request = URLRequest(url: url!)

        movieWebView.load(request)
        
        updateUI()
        
    }
    
    func updateUI() {
        titleLabel.text = selectedTitle
        ratingLabel.text = selectedRating
        directorLabel.text = selectedDirector
        actorLabel.text = selectedActor
        
        if let posterImg = selectedImgURL {
            let url = URL(string: posterImg)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.posterImg.image = UIImage(data: data!)
                }
            }
        } else {
            self.posterImg.image = UIImage(named: "movie_sample")
        }
        
    }
    
}
