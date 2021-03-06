//
//  MovieListCell.swift
//  DGV
//
//  Created by DaHae Kim on 2021/12/05.
//

import UIKit

class MovieListCell: UITableViewCell {

    @IBOutlet weak var posterImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    
    var link: MovieListViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let likeButton = UIButton(type: .custom)
        let image = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)
        likeButton.setImage(image, for: .normal)
        likeButton.tintColor = UIColor.green
        likeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

        likeButton.addTarget(self, action: #selector(handleMarkAsLike), for: .touchUpInside)
        
        accessoryView = likeButton
        
//        // Initialization code
//        likeBtn.addTarget(self, action: #selector(handleMarkAsLike), for: .touchUpInside)

    }

    @objc private func handleMarkAsLike() {
        print("marked!!!")
        link?.didLikeButtonTouched(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
