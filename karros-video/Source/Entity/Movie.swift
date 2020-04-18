//
//  Movie.swift
//  karros-video
//
//  Created by Hoang Lu on 4/16/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import ObjectMapper

fileprivate let baseImageURL = URL(string: "https://image.tmdb.org/t/p/")!

class Model: Mappable, Equatable {
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) { }
    
    static func == (lhs: Model, rhs: Model) -> Bool {
        return false
    }
}

enum PosterSize: String {
    case w92 = "w92"
    case w154 = "w154"
    case w185 = "w185"
    case w342 = "w342"
    case w500 = "w500"
    case w780 = "w780"
    case original = "original"
}

enum BackdropSize: String {
    case w300 = "w300"
    case w780 = "w780"
    case w1280 = "w1280"
    case original = "original"
}

class Movie: Model {
    var id: Int = 0
    var posterPath: String = ""
    var backdropPath: String = ""
    var title: String = ""
    var overview: String = ""
    var releaseDate: Date = Date()
    
    override func mapping(map: Map) {
        id <- map["id"]
        posterPath <- map["poster_path"]
        backdropPath <- map["backdrop_path"]
        title <- map["title"]
        overview <- map["overview"]
        releaseDate <- (map["release_date"], DateTransform())
    }
    
    func getPosterImageURL(size: PosterSize) -> URL {
        return baseImageURL
            .appendingPathComponent(size.rawValue)
            .appendingPathComponent(posterPath)
    }
    
    func getBackdropImageURL(size: BackdropSize) -> URL {
        return baseImageURL
            .appendingPathComponent(size.rawValue)
            .appendingPathComponent(backdropPath)
    }
}

extension Movie: Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }

}
