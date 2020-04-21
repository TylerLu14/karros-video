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
    
    lazy var btnPlay: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ic_play"), for: .normal)
        return button
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
        label.font = Font.helvetica.bold(withSize: 22)
        label.textColor = #colorLiteral(red: 0.9450980392, green: 0.7921568627, blue: 0.137254902, alpha: 1)
        return label
    }()
    
    lazy var imgStars: [UIImageView] = {
        return (0..<5).map{ _ in
            let imgStar = UIImageView()
            imgStar.image = #imageLiteral(resourceName: "ic_star_filled")
            imgStar.contentMode = .scaleAspectFit
            return imgStar
        }
    }()
    
    lazy var lblReleaseDate: UILabel = {
        let label = UILabel()
        label.font = Font.helvetica.normal(withSize: 14)
        label.textColor = .gray
        return label
    }()
    
    lazy var lblGenres: [UILabel] = {
        return (0..<2).map{ _ in
            let label = UILabel()
            label.font = Font.helvetica.normal(withSize: 14)
            label.backgroundColor = .systemBlue
            label.textColor = .white
            label.isHidden = true
            return label
        }
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
        
        view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)

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
        scrollView.addSubview(lblRating)
        scrollView.addSubview(btnPlay)
        
        imgBackdrop.snp.makeConstraints{ make in
            make.top.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(imgBackdrop.snp.width).dividedBy(1.6)
        }
        
        btnPlay.snp.makeConstraints{ make in
            make.center.equalTo(imgBackdrop.snp.center)
            make.size.equalTo(80)
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
        
        let stackStars = UIStackView(arrangedSubviews: [lblRating] + imgStars)
        scrollView.addSubview(stackStars)
        stackStars.spacing = 8
        stackStars.axis = .horizontal
        stackStars.alignment = .center
        stackStars.distribution = .fill
        stackStars.snp.makeConstraints{ make in
            make.left.equalTo(imgPoster.snp.right).offset(10)
            make.top.equalTo(imgBackdrop.snp.bottom).offset(10)
            make.height.equalTo(25)
        }
        
        imgStars.forEach{ star in
            star.snp.makeConstraints{ make in
                make.width.height.equalTo(20)
            }
        }
        
        scrollView.addSubview(lblReleaseDate)
        lblReleaseDate.snp.makeConstraints{ make in
            make.left.equalTo(imgPoster.snp.right).offset(10)
            make.top.equalTo(stackStars.snp.bottom)
        }
        
        let stackGenres = UIStackView(arrangedSubviews: lblGenres)
        scrollView.addSubview(stackGenres)
        stackGenres.spacing = 8
        stackGenres.axis = .horizontal
        stackGenres.alignment = .fill
        stackGenres.distribution = .fill
        stackGenres.snp.makeConstraints{ make in
            make.left.equalTo(imgPoster.snp.right).offset(10)
            make.top.equalTo(lblReleaseDate.snp.bottom).offset(5)
            make.height.equalTo(30)
        }
        
        let titleStack = UIStackView(arrangedSubviews: [lblTitle, lblOverview])
        titleStack.axis = .vertical
        titleStack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        titleStack.isLayoutMarginsRelativeArrangement = true
        
        let castStack = UIStackView(arrangedSubviews: [lblCast])
        castStack.axis = .vertical
        castStack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        castStack.isLayoutMarginsRelativeArrangement = true
        
        let recommendStack = UIStackView(arrangedSubviews: [lbRecommendation])
        recommendStack.axis = .vertical
        recommendStack.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        recommendStack.isLayoutMarginsRelativeArrangement = true
        
        let stackView = UIStackView(arrangedSubviews: [
            titleStack,
            btnFavourite,
            castStack,
            vcCasts.view,
            recommendStack,
            vcRecommends.view])
        
        addChild(vcCasts)
        addChild(vcRecommends)
        vcCasts.view.snp.makeConstraints{ make in
            make.height.equalTo(200)
        }
        vcRecommends.view.snp.makeConstraints{ make in
            make.height.equalTo(280)
        }
        scrollView.addSubview(stackView)
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 40
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
        
        //white backgrounds
        let bgCasts = UIView()
        scrollView.insertSubview(bgCasts, at: 0)
        bgCasts.backgroundColor = .white
        bgCasts.snp.makeConstraints{ make in
            make.top.bottom.equalTo(vcCasts.view).inset(-20)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        let bgRecommends = UIView()
        scrollView.insertSubview(bgRecommends, at: 0)
        bgRecommends.backgroundColor = .white
        bgRecommends.snp.makeConstraints{ make in
            make.top.bottom.equalTo(vcRecommends.view).inset(-20)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        let bgBackdrop = UIView()
        scrollView.insertSubview(bgBackdrop, at: 0)
        bgBackdrop.backgroundColor = .white
        bgBackdrop.snp.makeConstraints{ make in
            make.top.equalTo(imgBackdrop)
            make.bottom.equalTo(btnFavourite).inset(-20)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        lblGenres.forEach{ lbl in
            lbl.clipsToBounds = true
            lbl.layer.cornerRadius = lbl.bounds.height/2
        }
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        btnBack.rx.tap
            .subscribe(onNext: { [unowned self] _ in self.dismiss(animated: true) })
            .disposed(by: disposeBag)
        
        lblRating.text = "\(viewModel.model.voteAverage/2)"
        imgStars.enumerated().forEach{ index, star in
            star.image = index < Int((viewModel.model.voteAverage/2).rounded()) ? #imageLiteral(resourceName: "ic_star_filled") : #imageLiteral(resourceName: "ic_star_unfilled")
        }
        lblReleaseDate.text = viewModel.model.releaseDateString
        
        lblGenres.forEach{ $0.isHidden = true }
        viewModel.model
            .genres[0..<min(viewModel.model.genres.count,lblGenres.count)]
            .enumerated()
            .forEach{ index, genre in
                lblGenres[index].text = "   \(genre.description)   "
                lblGenres[index].isHidden = false
            }
        
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
