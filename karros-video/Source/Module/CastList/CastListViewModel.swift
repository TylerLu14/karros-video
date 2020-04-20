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

class CastListViewModel: ListViewModel<CastCellViewModel> {
    let service: IImdbService
    
    lazy var fetchCreditsAction =  {
        return Action<Int,Credit> { [unowned self] id in
            return self.service.getMovieCredits(id: id)
        }
    }()
    
    init(service: IImdbService = dependencyManager.getService()) {
        self.service = service
    }
    
    override func react() {
        super.react()
        
        fetchCreditsAction.elements
            .map{ [unowned self] credit in
                let casts = credit.casts.sorted{ $0.order < $1.order }
                return self.makeSources(casts) }
            .bind(to: itemsSource)
            .disposed(by: disposeBag)
    }
}
