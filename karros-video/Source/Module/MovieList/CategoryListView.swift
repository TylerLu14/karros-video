//
//  CategoryListView.swift
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

class CategoryListViewController: BaseCollectionViewController<CategoryListViewModel> {
    override func setupLayout() {
        super.setupLayout()
        (layout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
    }
    
    override func initialize() {
        super.initialize()
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        collectionView.register(MovieVerticalCell.self, forCellWithReuseIdentifier: MovieVerticalCell.identifier)
        collectionView.register(MovieHorizontalCell.self, forCellWithReuseIdentifier: MovieHorizontalCell.identifier)
        collectionView.snp.makeConstraints{ make in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    override func cellIdentifier(_ cellViewModel: MovieCellViewModel) -> String {
        switch viewModel.category.value {
        case .recommend: return MovieHorizontalCell.identifier
        default: return MovieVerticalCell.identifier
        }
    }
    
    override func configureCell(_ dataSource: CollectionDataSourceType, collectionView: UICollectionView, indexPath: IndexPath, cellViewModel: MovieCellViewModel) -> UICollectionViewCell {
        let identifier = cellIdentifier(cellViewModel)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MovieCell
        cell.viewModel = cellViewModel
        return cell
    }
}

extension CategoryListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.category.value {
        case .recommend: return CGSize(width: collectionView.frame.size.width * 0.8, height: collectionView.frame.size.height)
        default: return CGSize(width: collectionView.frame.size.width * 0.4, height: collectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

class CategoryListViewModel: ListViewModel<MovieCellViewModel> {
    let category = BehaviorRelay<Category>(value: .none)
}
