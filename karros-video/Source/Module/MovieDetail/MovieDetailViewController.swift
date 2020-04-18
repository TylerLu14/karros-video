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
    lazy var imgBackdrop: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        return img
    }()
    
    lazy var imgPoster: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        return img
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
        label.font = Font.helvetica.normal(withSize: 14)
        return label
    }()
    
    lazy var lblOverview: UILabel = {
        let label = UILabel()
        label.font = Font.helvetica.normal(withSize: 14)
        return label
    }()
    
    lazy var btnReadMore: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override func initialize() {
        super.initialize()
       
        view.addSubview(imgBackdrop)
        view.addSubview(imgPoster)
    }
}
