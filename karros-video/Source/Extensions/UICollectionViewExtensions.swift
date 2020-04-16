//
//  UICollectionViewExtensions.swift
//  karros-video
//
//  Created by Hoang Lu on 4/16/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    func endReachY(offset: CGFloat = 35.0) -> Observable<Bool> {
        return contentOffset.map{ [base] contentOffset in
            let scrollViewHeight = base.frame.size.height
            let scrollContentSizeHeight = base.contentSize.height
            let scrollOffset = contentOffset.y
            let scrollSize = scrollOffset + scrollViewHeight
            
            return scrollSize > scrollContentSizeHeight + offset
        }
        .distinctUntilChanged()
    }
    
    func endReachX(offset: CGFloat = 35.0) -> Observable<Bool> {
        return contentOffset.map{ [base] contentOffset in
            let scrollViewWidth = base.frame.size.width
            let scrollContentSizeWidth = base.contentSize.width
            let scrollOffset = contentOffset.x
            let scrollSize = scrollOffset + scrollViewWidth
            
            return scrollSize > scrollContentSizeWidth + offset
        }
        .distinctUntilChanged()
    }
}
