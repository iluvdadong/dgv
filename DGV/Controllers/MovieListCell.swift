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
    @IBOutlet weak var likeBtn: UIButton!
    
    var link: MovieListViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        likeBtn.addTarget(self, action: #selector(handleMarkAsLike), for: .touchUpInside)

    }

    @objc private func handleMarkAsLike() {
        print("marked!!!")
        link?.someMethodIWanttocall(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
