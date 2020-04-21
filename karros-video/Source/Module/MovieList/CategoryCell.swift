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
    
    lazy var imgArrow: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "ic_arrow")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let collectionVC = MoviesCollectionViewController(viewModel: MoviceCollectionViewModel())
    
    override func initialize() {
        super.initialize()
        selectedBackgroundView = UIView()
        
        contentView.addSubview(collectionVC.view)
        contentView.addSubview(lblTitle)
        contentView.addSubview(imgArrow)
        
        lblTitle.snp.makeConstraints{ make in
            make.left.equalToSuperview().offset(8)
            make.top.equalToSuperview()
            make.height.equalTo(40)
        }
        
        imgArrow.snp.makeConstraints{ make in
            make.centerY.equalTo(lblTitle.snp.centerY)
            make.left.equalTo(lblTitle.snp.right)
            make.right.equalToSuperview().inset(20)
            make.size.equalTo(22)
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
        
        collectionVC.collectionView.rx.endReachX(offset: -10)
            .distinctUntilChanged()
            .filter{ $0 }
            .map{ _ in () }
            .bind(to: viewModel.fetchItemAction.inputs)
            .disposed(by: disposeBag)
        
        viewModel.movies
            .map{ [unowned self] movies in self.collectionVC.viewModel.makeSources(movies) }
            .bind(to: collectionVC.viewModel.itemsSource)
            .disposed(by: disposeBag)
        
        viewModel.refreshAction.elements
            .asDriver{ _ in .empty() }
            .drive(onNext: { [collectionVC] _ in
                collectionVC.collectionView.scrollToItem(
                    at: IndexPath(row: 0, section: 0),
                    at: .left, animated: true)
            })
            .disposed(by: disposeBag)
        
        collectionVC.viewModel.selectedItem
            .map{ $0.model }
            .bind(to: viewModel.selectedMovie)
            .disposed(by: disposeBag)
    }
    
}

class CategoryCellViewModel: CellViewModel {
    let service: IImdbService
    
    let category = BehaviorRelay<Category>(value: .none)
    let movies = BehaviorRelay<[Movie]>(value: [])
    let selectedMovie = PublishRelay<Movie>()
    var currentPage = 1
    var maxPage = 20
    
    lazy var refreshAction =  {
        return Action<Void?,[Movie]> { [unowned self] page in
            self.currentPage = 1
            return self.service.getMovies(router: self.getRouter(category: self.category.value, page: self.currentPage))
            .asObservable()
        }
    }()
    
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
                fetchedMovies.forEach{ $0.page = self.currentPage }
                self.currentPage += 1
                self.movies.accept(self.movies.value + fetchedMovies)
            })
            .disposed(by: disposeBag)
        
        refreshAction.elements
            .subscribe(onNext: { [unowned self] fetchedMovies in
                guard fetchedMovies.count > 0 else {
                    self.maxPage = self.currentPage - 1
                    return
                }
                fetchedMovies.forEach{ $0.page = self.currentPage }
                self.currentPage += 1
                self.movies.accept(fetchedMovies)
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
