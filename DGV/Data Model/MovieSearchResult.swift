//
//  Movie.swift
//  DGV
//
//  Created by DaHae Kim on 2021/12/04.
//

import Foundation
import UIKit

struct MovieSearchResult: Codable {
    var items: [Movie]
    
    struct Movie: Codable {
        var title: String?
        var link: String?
        var image: String?
        var subtitle: String?
        var pubDate: String?
        var director: String?
        var actor: String?
        var userRating: String?
        var hasLiked: Bool?
    }
    
}
