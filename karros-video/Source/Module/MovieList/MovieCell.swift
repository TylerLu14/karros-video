//
//  MovieCell.swift
//  karros-video
//
//  Created by Hoang Lu on 4/16/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MovieCell: BaseCollectionCell<MovieCellViewModel> {
    
    static let identifier = "MovieCell"
    
    private lazy var imgPoster: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 10
        img.layer.masksToBounds = true
        return img
    }()
    
    private lazy var shadowView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .black
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 15)
        view.layer.shadowRadius = 5
        return view
    }()
    
    private lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.font = Font.helvetica.bold(withSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    override func initialize() {
        addSubview(shadowView)
        addSubview(imgPoster)
        
        imgPoster.snp.makeConstraints{ make in
            make.top.left.right.equalToSuperview()
        }
        
        shadowView.snp.makeConstraints{ make in
            make.top.left.equalTo(imgPoster).offset(5)
            make.bottom.right.equalTo(imgPoster).offset(-5)
        }
        
        let wrapper = UIView()
        addSubview(wrapper)
        
        wrapper.snp.makeConstraints{ make in
            make.top.equalTo(imgPoster.snp.bottom).offset(10)
            make.left.bottom.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(40)
        }
        wrapper.addSubview(lblTitle)
        lblTitle.snp.makeConstraints{ make in
            make.top.left.right.equalToSuperview()
        }
    
    }
    
    override func bindViewAndViewModel() {
        lblTitle.text = viewModel.model.title
        viewModel.image.filterNil()
            .bind(to: imgPoster.rx.networkImage)
            .disposed(by: disposeBag)
    }
    
}

class MovieCellViewModel: CellViewModel, HasModel {
    
    typealias ModelElement = Movie
    var model: Movie
    var image = BehaviorRelay<NetworkImage?>(value: nil)
    
    override var identity: String {
        return String(model.id)
    }
    
    required init(model: Movie) {
        self.model = model
        self.image.accept(NetworkImage(model.posterURL))
    }
}
