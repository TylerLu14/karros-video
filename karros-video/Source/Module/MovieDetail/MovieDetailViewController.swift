//
//  MovieDetailViewController.swift
//  karros-video
//
//  Created by Hoang Lu on 4/18/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailViewController: BaseViewController<MovieDetailViewModel> {
    lazy var btnBack: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_back"), for: .normal)
        return button
    }()
    
    lazy var imgBackdrop: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        return img
    }()
    
    lazy var imgPoster: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 10
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
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
    
    lazy var lblRating: UILabel = {
        let label = UILabel()
        label.font = Font.helvetica.normal(withSize: 14)
        return label
    }()
    
    lazy var imgStars: [UIImageView] = {
        return (0..<5).map{ _ in
            let imgStar = UIImageView()
            imgStar.contentMode = .scaleAspectFit
            return imgStar
        }
    }()
    
    lazy var lblReleaseDate: UILabel = {
        let label = UILabel()
        label.font = Font.helvetica.normal(withSize: 14)
        return label
    }()
    
    lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.font = Font.helvetica.bold(withSize: 24)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var lblOverview: UILabel = {
        let label = UILabel()
        label.font = Font.helvetica.normal(withSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    lazy var btnFavourite: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_btn_favourite"), for: .normal)
        return button
    }()
    
    lazy var lblCast: UILabel = {
        let label = UILabel()
        label.text = "Series Cast"
        label.font = Font.helvetica.bold(withSize: 20)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var vcCasts: CastListViewController = {
        let vc = CastListViewController(viewModel: CastListViewModel())
        return vc
    }()
    
    lazy var lbRecommendation: UILabel = {
        let label = UILabel()
        label.text = "Recommendations"
        label.font = Font.helvetica.bold(withSize: 20)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var vcRecommends: ReccomendListViewController = {
        let vc = ReccomendListViewController(viewModel: RecommendListViewModel())
        return vc
    }()
    
    override func initialize() {
        super.initialize()
        
        view.backgroundColor = .white
        
        view.addSubview(btnBack)
        btnBack.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(20)
        }
        
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.addSubview(imgBackdrop)
        scrollView.addSubview(shadowView)
        scrollView.addSubview(imgPoster)
        
        imgBackdrop.snp.makeConstraints{ make in
            make.top.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(imgBackdrop.snp.width).dividedBy(1.6)
        }
        
        imgPoster.snp.makeConstraints{ make in
            make.centerY.equalTo(imgBackdrop.snp.bottom)
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(180)
            make.width.equalTo(120)
        }
        shadowView.snp.makeConstraints{ make in
            make.top.left.equalTo(imgPoster).offset(5)
            make.bottom.right.equalTo(imgPoster).offset(-5)
        }
        
        let stackView = UIStackView(arrangedSubviews: [
            lblTitle, lblOverview, btnFavourite,
            lblCast, vcCasts.view,
            lbRecommendation, vcRecommends.view])
        addChild(vcCasts)
        addChild(vcRecommends)
        vcCasts.view.snp.makeConstraints{ make in
            make.height.equalTo(200)
        }
        vcRecommends.view.snp.makeConstraints{ make in
            make.height.equalTo(280)
        }
        scrollView.addSubview(stackView)
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.snp.makeConstraints{ make in
            make.top.equalTo(imgPoster.snp.bottom)
            make.width.equalToSuperview()
            make.left.bottom.equalToSuperview()
        }
        
        view.insertSubview(scrollView, at: 0)
        scrollView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        btnBack.rx.tap
            .subscribe(onNext: { _ in self.dismiss(animated: true) })
            .disposed(by: disposeBag)
        
        lblTitle.text = viewModel.model.title.uppercased()
        lblOverview.text = viewModel.model.overview
        
        vcCasts.viewModel.fetchCreditsAction.execute(viewModel.model.id)
        vcRecommends.viewModel.fetchRecommendsAction.execute((viewModel.model.id, 1))
        
        viewModel.posterImage.filterNil()
            .bind(to: imgPoster.rx.networkImage)
            .disposed(by: disposeBag)
        
        viewModel.backdropImage.filterNil()
            .bind(to: imgBackdrop.rx.networkImage)
            .disposed(by: disposeBag)
    }
}
