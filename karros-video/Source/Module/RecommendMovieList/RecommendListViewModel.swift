//
//  CastListViewModel.swift
//  karros-video
//
//  Created by Hoang Lu on 4/18/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class RecommendListViewModel: ListViewModel<MovieCellViewModel> {
    let service: IImdbService
    
    lazy var fetchRecommendsAction =  {
        return Action<(Int,Int),[Movie]> { [unowned self] id, page in
            return self.service.getRecommends(fromMovieId: id, page: page)
        }
    }()
    
    init(service: IImdbService = dependencyManager.getService()) {
        self.service = service
    }
    
    override func react() {
        super.react()
        
        fetchRecommendsAction.elements
            .map{[unowned self] movies in self.makeSources(movies) }
            .bind(to: itemsSource)
            .disposed(by: disposeBag)
    }
}
