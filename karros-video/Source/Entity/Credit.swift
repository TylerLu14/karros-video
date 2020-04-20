//
//  Cast.swift
//  karros-video
//
//  Created by Hoang Lu on 4/21/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import ObjectMapper

enum ProfileSize: String {
    case w45 = "w45"
    case w185 = "w185"
    case w632 = "h632"
    case original = "original"
}

class Credit: Model {
    var casts: [Cast] = []
    var crews: [Crew] = []
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        casts <- map["cast"]
        crews <- map["crew"]
    }
}

class Person: Model {
    var id: Int = 0
    var name: String = ""
    var profilePath: String = ""
    var order: Int = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["cast_id"]
        name <- map["name"]
        profilePath <- map["profile_path"]
        order <- map["order"]
    }
    
    func getProfileImageURL(size: ProfileSize) -> URL {
        return baseImageURL
            .appendingPathComponent(size.rawValue)
            .appendingPathComponent(profilePath)
    }
}

class Cast: Person {
    var character: String = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        character <- map["character"]
    }
}

class Crew: Person {
    var job: String = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        job <- map["job"]
    }
}
