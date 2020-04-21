//
//  MovieListViewModel.swift
//  karros-video
//
//  Created by Hoang Lu on 4/16/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import RxSwift
import Action

enum Category: String {
    case none = "None"
    case recommend = "Recommendations"
    case popular = "Popular"
    case topRated = "Top Rated"
    case upcoming = "Upcoming"
    static var allCategories: [Category] {
        return [.recommend, .popular, .topRated, .upcoming]
    }
}

class MovieMasterListViewModel: ListViewModel<CategoryCellViewModel> {
    lazy var refreshAction =  {
        return Action<Void?, Void> { [unowned self] _ in
            return .just(())
        }
    }()
    
    
    override func react() {
        super.react()
        let items = Category.allCategories.map{ CategoryCellViewModel(category: $0) }
        itemsSource.accept(makeSources(items))
        
        refreshAction.elements
            .subscribe(onNext: { [itemsSource] in
                guard let cvms = itemsSource.value.first?.items else { return }
                cvms.forEach{ cvm in cvm.refreshAction.execute(nil) }
            })
            .disposed(by: disposeBag)
    }
    
}
