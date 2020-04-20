//
//  CastListViewController.swift
//  karros-video
//
//  Created by Hoang Lu on 4/18/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import UIKit

class CastListViewController: BaseCollectionViewController<CastListViewModel> {
    override func setupLayout() {
        super.setupLayout()
        (layout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
    }
    
    override func initialize() {
        super.initialize()
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        collectionView.register(CastCell.self, forCellWithReuseIdentifier: CastCell.identifier)
        collectionView.snp.makeConstraints{ make in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    override func cellIdentifier(_ cellViewModel: CastCellViewModel) -> String {
        return CastCell.identifier
    }
}

extension CastListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3.5, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
