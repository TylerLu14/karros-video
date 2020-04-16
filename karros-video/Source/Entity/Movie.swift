//
//  Movie.swift
//  karros-video
//
//  Created by Hoang Lu on 4/16/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import ObjectMapper

fileprivate let baseImageURL = URL(string: "https://image.tmdb.org/t/p/w500/")!

class Model: Mappable, Equatable {
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) { }
    
    static func == (lhs: Model, rhs: Model) -> Bool {
        return false
    }
}

class Movie: Model {
    var id: Int = 0
    var posterPath: String = ""
    var posterURL: URL {
        return baseImageURL.appendingPathComponent(posterPath)
    }
    var title: String = ""
    var overview: String = ""
    var releaseDate: Date = Date()
    
    override func mapping(map: Map) {
        id <- map["id"]
        posterPath <- map["poster_path"]
        title <- map["title"]
        overview <- map["overview"]
        releaseDate <- (map["release_date"], DateTransform())
    }
}
