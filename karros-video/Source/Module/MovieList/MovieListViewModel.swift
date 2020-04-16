//
//  MovieListViewModel.swift
//  karros-video
//
//  Created by Hoang Lu on 4/16/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation

enum Category: String {
    case none = "None"
    case recommend = "Recommendations"
    case popular = "Popular"
    case topRated = "Top Rated"
    case upcoming = "Upcoming"
    static var allCategories: [Category] {
        //return [.recommend, .popular, .topRated, .upcoming]
        return [.upcoming]
    }
}

class MovieListViewModel: ListViewModel<CategoryCellViewModel> {
    
    override func react() {
        super.react()
        let items = Category.allCategories.map{ CategoryCellViewModel(category: $0) }
        itemsSource.accept(makeSources(items))
    }
    
}
