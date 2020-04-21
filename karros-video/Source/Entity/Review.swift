//
//  Review.swift
//  karros-video
//
//  Created by Hoang Lu on 4/21/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import ObjectMapper

class Review: Model {
    var author: String = ""
    var content: String = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        author <- map["author"]
        content <- map["content"]
    }
}
