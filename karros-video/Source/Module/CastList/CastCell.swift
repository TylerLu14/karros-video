//
//  CastCell.swift
//  karros-video
//
//  Created by Hoang Lu on 4/18/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CastCell: BaseCollectionCell<CastCellViewModel> {
    static let identifier = "PotraitMovieCell"
    
    lazy var imgProfile: UIImageView = {
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
    
    private lazy var lblName: UILabel = {
        let label = UILabel()
        label.font = Font.helvetica.bold(withSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var lblCharacter: UILabel = {
        let label = UILabel()
        label.font = Font.helvetica.normal(withSize: 14)
        label.textColor = .gray
        return label
    }()
    
    override func initialize() {
        
        contentView.addSubview(shadowView)
        contentView.addSubview(imgProfile)
        contentView.addSubview(lblName)
        contentView.addSubview(lblCharacter)
        
        imgProfile.snp.makeConstraints{ make in
            make.top.left.right.equalToSuperview()
        }
        shadowView.snp.makeConstraints{ make in
            make.top.left.equalTo(imgProfile).offset(5)
            make.bottom.right.equalTo(imgProfile).offset(-5)
        }
        
        lblName.snp.makeConstraints{ make in
            make.top.equalTo(imgProfile.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        lblCharacter.snp.makeConstraints{ make in
            make.top.equalTo(lblName.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shadowView.isHidden = true
        imgProfile.image = nil
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        lblName.text = viewModel.model.name
        lblCharacter.text = viewModel.model.character
        
        viewModel.profileImage.filterNil()
            .do(onNext:{ [unowned self] _ in self.shadowView.isHidden = false })
            .bind(to: imgProfile.rx.networkImage)
            .disposed(by: disposeBag)
    }
}

class CastCellViewModel: CellViewModel, HasModel {
    typealias ModelElement = Cast
    let model: Cast
    let profileImage = BehaviorRelay<NetworkImage?>(value: nil)
    
    required init(model: Cast) {
        self.model = model
        profileImage.accept(NetworkImage(model.getProfileImageURL(size: .w185), placeholder: #imageLiteral(resourceName: "ic_image_placeholder")))
    }
    
}

