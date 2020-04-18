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
    lazy var imgPoster: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 10
        img.layer.masksToBounds = true
        return img
    }()
    
    lazy var shadowView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 15)
        view.layer.shadowRadius = 5
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shadowView.isHidden = true
        imgPoster.image = nil
    }
}

class PotraitMovieCell: MovieCell {
    static let identifier = "PotraitMovieCell"
    
    private lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.font = Font.helvetica.bold(withSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var btnDetail: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_detail"), for: .normal)
        return button
    }()
    
    override func initialize() {
        let wrapper = UIView()
        wrapper.addSubview(lblTitle)
        wrapper.addSubview(btnDetail)
        
        contentView.addSubview(shadowView)
        contentView.addSubview(imgPoster)
        contentView.addSubview(wrapper)
        
        imgPoster.snp.makeConstraints{ make in
            make.top.left.right.equalToSuperview()
        }
        shadowView.snp.makeConstraints{ make in
            make.top.left.equalTo(imgPoster).offset(5)
            make.bottom.right.equalTo(imgPoster).offset(-5)
        }
        
        wrapper.snp.makeConstraints{ make in
            make.top.equalTo(imgPoster.snp.bottom).offset(8)
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(40)
        }
        lblTitle.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(3)
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(btnDetail.snp.left).offset(-5)
        }
        btnDetail.snp.makeConstraints{ make in
            make.top.right.equalToSuperview()
            make.width.equalTo(10)
        }
    }
    
    override func bindViewAndViewModel() {
        lblTitle.text = viewModel.model.title
        viewModel.posterImage.filterNil()
            .do(onNext:{ [unowned self] _ in self.shadowView.isHidden = false })
            .bind(to: imgPoster.rx.networkImage)
            .disposed(by: disposeBag)
    }
}

class LandscapeMovieCell: MovieCell {
    static let identifier = "LandscapeMovieCell"
    
    override func initialize() {
        addSubview(shadowView)
        addSubview(imgPoster)
        
        imgPoster.snp.makeConstraints{ make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
        shadowView.snp.makeConstraints{ make in
            make.top.left.equalTo(imgPoster).offset(5)
            make.bottom.right.equalTo(imgPoster).offset(-5)
        }
    }
    
    override func bindViewAndViewModel() {
        
        viewModel.backdropImage.filterNil()
            .do(onNext:{ [unowned self] _ in self.shadowView.isHidden = false })
            .bind(to: imgPoster.rx.networkImage)
            .disposed(by: disposeBag)
    }
}

class MovieCellViewModel: CellViewModel, HasModel {
    
    typealias ModelElement = Movie
    var model: Movie
    var posterImage = BehaviorRelay<NetworkImage?>(value: nil)
    var backdropImage = BehaviorRelay<NetworkImage?>(value: nil)
    
    override var identity: String {
        return String(model.id)
    }
    
    required init(model: Movie) {
        self.model = model
        self.posterImage.accept(NetworkImage(model.getPosterImageURL(size: .w342), placeholder: #imageLiteral(resourceName: "ic_image_placeholder")))
        self.backdropImage.accept(NetworkImage(model.getBackdropImageURL(size: .w780), placeholder: #imageLiteral(resourceName: "ic_image_placeholder")))
    }
}
