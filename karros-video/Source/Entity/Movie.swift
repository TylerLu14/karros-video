//
//  Movie.swift
//  karros-video
//
//  Created by Hoang Lu on 4/16/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import ObjectMapper

let baseImageURL = URL(string: "https://image.tmdb.org/t/p/")!

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

enum Genre: Int {
    case action = 28
    case adventure = 12
    case animation = 16
    case comedy = 35
    case crime = 80
    case documentary = 99
    case drama = 18
    case family = 10751
    case fantasy = 14
    case history = 36
    case horror = 27
    case music = 10402
    case mystery = 9648
    case romance = 10749
    case scifi = 878
    case tv = 10770
    case thriller = 53
    case war = 10752
    case western = 37
}

extension Genre: CustomStringConvertible {
    var description: String {
        switch self {
        case .action: return "Action"
        case .adventure: return "Adventure"
        case .animation: return "Animation"
        case .comedy: return "Comedy"
        case .crime: return "Crime"
        case .documentary: return "Documentary"
        case .drama: return "Drama"
        case .family: return "Family"
        case .fantasy: return "Fantasy"
        case .history: return "History"
        case .horror: return "Horror"
        case .music: return "Music"
        case .mystery: return "Mystery"
        case .romance: return "Romance"
        case .scifi: return "Science Fiction"
        case .tv: return "TV Movie"
        case .thriller: return "Thriller"
        case .war: return "War"
        case .western: return "Western"
        }
    }
}

class Movie: Model {
    var id: Int = 0
    var posterPath: String = ""
    var backdropPath: String = ""
    var title: String = ""
    var overview: String = ""
    var releaseDate: Date = Date()
    var voteAverage: Float = 0
    var genres: [Genre] = []
    
    var page: Int = 0
    
    var releaseDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: releaseDate)
    }
    
    override func mapping(map: Map) {
        id <- map["id"]
        posterPath <- map["poster_path"]
        backdropPath <- map["backdrop_path"]
        title <- map["title"]
        overview <- map["overview"]
        releaseDate <- (map["release_date"], DateTransform())
        voteAverage <- map["vote_average"]
        genres <- map["genre_ids"]
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
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


