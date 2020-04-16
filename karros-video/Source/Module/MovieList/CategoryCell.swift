//
//  CategoryCell.swift
//  karros-video
//
//  Created by Hoang Lu on 4/16/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import Action

class CategoryCell: BaseTableCell<CategoryCellViewModel> {
    static let identifier = "CategoryCell"
    lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = Font.helvetica.bold(withSize: 16)
        return label
    }()
    let collectionVC = CategoryListViewController(viewModel: CategoryListViewModel())
    
    override func initialize() {
        super.initialize()
        selectedBackgroundView = UIView()
        
        contentView.addSubview(collectionVC.view)
        contentView.addSubview(lblTitle)
        
        lblTitle.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(8)
            make.top.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        collectionVC.view.snp.makeConstraints{ make in
            make.top.equalTo(lblTitle.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        lblTitle.text = viewModel.category.value.rawValue.uppercased()
        
        viewModel.category.bind(to: collectionVC.viewModel.category)
            .disposed(by: disposeBag)
        
        collectionVC.collectionView.rx.endReachX()
            .distinctUntilChanged()
            .filter{ $0 }
            .map{ _ in () }
            .bind(to: viewModel.fetchItemAction.inputs)
            .disposed(by: disposeBag)
        
        viewModel.movies
            .map{ [unowned self] movies in self.collectionVC.viewModel.makeSources(movies) }
            .bind(to: collectionVC.viewModel.itemsSource)
            .disposed(by: disposeBag)
    }
    
}

class CategoryCellViewModel: CellViewModel {
    let service: IImdbService
    
    let category = BehaviorRelay<Category>(value: .none)
    let movies = BehaviorRelay<[Movie]>(value: [])
    var currentPage = 1
    var maxPage = 20
    
    lazy var fetchItemAction =  {
        return Action<Void,[Movie]> { [unowned self] page in
            guard self.currentPage <= self.maxPage else { return .empty() }
            return self.service.getMovies(router: self.getRouter(category: self.category.value, page: self.currentPage))
                .asObservable()
        }
    }()
    
    init(category: Category, service: IImdbService = dependencyManager.getService()) {
        self.service = service
        self.category.accept(category)
    }
    
    override func react() {
        super.react()
        
        fetchItemAction.elements
            .subscribe(onNext: { [unowned self] fetchedMovies in
                guard fetchedMovies.count > 0 else {
                    self.maxPage = self.currentPage - 1
                    return
                }
                self.currentPage += 1
                self.movies.accept(self.movies.value + fetchedMovies)
            })
            .disposed(by: disposeBag)
    }
    
    func getRouter(category: Category, page: Int) -> ImdbRouter {
        switch category {
        case .recommend: return ImdbRouter.getNowPlaying(page: page)
        case .popular: return ImdbRouter.getPopular(page: page)
        case .topRated: return ImdbRouter.getTopRated(page: page)
        case .upcoming: return ImdbRouter.getUpcoming(page: page)
        default: fatalError()
        }
    }
}
