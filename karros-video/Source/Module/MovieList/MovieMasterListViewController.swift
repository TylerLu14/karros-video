//
//  MovieListViewController.swift
//  karros-video
//
//  Created by Hoang Lu on 4/16/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Action

class MovieMasterListNavigator: Navigator {
    enum Destination {
        case detail(movie: Movie)
    }
    
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .detail(let movie):
            return MovieDetailViewController(viewModel: MovieDetailViewModel(model: movie))
        }
    }
}

class MovieMasterListViewController: BaseTableViewController<MovieMasterListViewModel> {
    let navigator: MovieMasterListNavigator
    
    lazy var imgTitle: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = #imageLiteral(resourceName: "ic_log")
        return img
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
    
    init(viewModel: MovieMasterListViewModel, navigator: MovieMasterListNavigator) {
        self.navigator = navigator
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func initialize() {
        super.initialize()
        view.backgroundColor = .white
        
        navigationItem.titleView = imgTitle
        
        tableView.snp.makeConstraints{ make in
            make.top.left.bottom.right.equalToSuperview()
        }
        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.rx.bind(to: viewModel.refreshAction, input: nil)   
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        viewModel.itemsSource
            .map{ $0.first?.items }
            .filterNil()
            .flatMapLatest{ cvms -> Observable<Movie> in
                Observable.merge(cvms.map{ $0.selectedMovie.asObservable() })
            }
            .subscribe(onNext: { [navigator] movie in navigator.present(to: .detail(movie: movie)) })
            .disposed(by: disposeBag)
    }
    
    override func cellIdentifier(_ cellViewModel: CellViewModel) -> String {
        return CategoryCell.identifier
    }
    
    override func configureCell(_ dataSource: TableDataSourceType, tableView: UITableView, indexPath: IndexPath, cellViewModel: CategoryCellViewModel) -> UITableViewCell {
        let identifier = cellIdentifier(cellViewModel)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        (cell as? CategoryCell)?.viewModel = cellViewModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cvm = viewModel.itemAt(indexPath) else { return 0 }
        switch cvm.category.value {
        case .recommend: return 230
        default: return 360
        }
    }
    
    @objc func refreshData(_ sender: UIRefreshControl) {
        
    }
}
