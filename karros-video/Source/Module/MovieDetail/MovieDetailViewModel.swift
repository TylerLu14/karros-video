//
//  MovieDetailViewModel.swift
//  karros-video
//
//  Created by Hoang Lu on 4/18/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation

class MovieDetailViewModel: BaseViewModel , HasModel {
    typealias ModelElement = Movie
    let model: Movie
    
    required init(model: Movie) {
        self.model = model
    }
    
    override func react() {
        super.react()
    }
}
