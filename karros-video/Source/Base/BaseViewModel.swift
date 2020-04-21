//
//  BaseViewModel.swift
//  cinemaxxi
//
//  Created by Hoang Lu on 10/31/19.
//  Copyright © 2019 Lu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ViewState {
    case none, willAppear, didAppear, willDisappear, didDisappear
}

class BaseViewModel: NSObject, GenericViewModel {
    var disposeBag: DisposeBag! = DisposeBag()
    
    let viewState = BehaviorRelay<ViewState>(value: .none)
    
    func destroy() {
        disposeBag = nil
    }
    
    func react() { }
    
    deinit {
        print("Deinit", self)
    }
}
