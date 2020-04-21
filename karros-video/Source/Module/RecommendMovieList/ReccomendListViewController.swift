//
//  CastListViewController.swift
//  karros-video
//
//  Created by Hoang Lu on 4/18/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import UIKit

class ReccomendListViewController: BaseCollectionViewController<RecommendListViewModel> {
    override func setupLayout() {
        super.setupLayout()
        (layout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
    }
    
    override func initialize() {
        super.initialize()
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        collectionView.register(PotraitMovieCell.self, forCellWithReuseIdentifier: PotraitMovieCell.identifier)
        collectionView.snp.makeConstraints{ make in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    override func cellIdentifier(_ cellViewModel: MovieCellViewModel) -> String {
        return PotraitMovieCell.identifier
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
    }
}

extension ReccomendListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
