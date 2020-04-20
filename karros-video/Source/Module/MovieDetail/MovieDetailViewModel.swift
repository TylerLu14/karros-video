//
//  MovieDetailViewModel.swift
//  karros-video
//
//  Created by Hoang Lu on 4/18/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieDetailViewModel: BaseViewModel , HasModel {
    typealias ModelElement = Movie
    let model: Movie
    
    var posterImage = BehaviorRelay<NetworkImage?>(value: nil)
    var backdropImage = BehaviorRelay<NetworkImage?>(value: nil)
    
    required init(model: Movie) {
        self.model = model
    }
    
    override func react() {
        super.react()
        
        self.posterImage.accept(NetworkImage(model.getPosterImageURL(size: .w342), placeholder: #imageLiteral(resourceName: "ic_image_placeholder")))
        self.backdropImage.accept(NetworkImage(model.getBackdropImageURL(size: .w780), placeholder: #imageLiteral(resourceName: "ic_image_placeholder")))
    }
}
