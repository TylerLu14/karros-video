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

class MovieListNavigator: Navigator {
    enum Destination {
        
    }
    
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func makeViewController(for destination: Destination) -> UIViewController {
    }
}

class MovieListViewController: BaseTableViewController<MovieListViewModel> {
    let navigator: MovieListNavigator
    
    lazy var imgTitle: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = #imageLiteral(resourceName: "ic_log")
        return img
    }()
    
    init(viewModel: MovieListViewModel, navigator: MovieListNavigator) {
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
        tableView.separatorStyle = .none
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
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
        default: return 340
        }
    }
}
