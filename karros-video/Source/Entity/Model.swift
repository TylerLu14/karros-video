//
//  Model.swift
//  karros-video
//
//  Created by Hoang Lu on 4/21/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import ObjectMapper

class Model: Mappable, Equatable {
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) { }
    
    static func == (lhs: Model, rhs: Model) -> Bool {
        return false
    }
}
