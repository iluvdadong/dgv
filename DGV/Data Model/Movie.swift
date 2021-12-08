//
//  Movie.swift
//  DGV
//
//  Created by DaHae Kim on 2021/12/04.
//

import Foundation
import UIKit

struct MovieSearchResult: Codable {
    let items: [Movie]
    struct Movie: Codable {
        var title: String?
        var link: String?
        var image: String?
        var subtitle: String?
        var pubDate: String?
        var director: String?
        var actor: String?
        var userRating: String?
    }
}

//    mutating func getPosterImg() {
//        guard imgURL != nil else {
//            return
//        }
//        if let url = URL(string: imgURL!) {
//            if let imgData = try? Data(contentsOf: url) {
//                if let image = UIImage(data: imgData) {
//                    self.image = image
//                }
//            }
//        }
//
//    }

