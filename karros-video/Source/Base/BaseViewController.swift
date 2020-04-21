//
//  BaseViewController.swift
//  cinemaxxi
//
//  Created by Hoang Lu on 10/31/19.
//  Copyright © 2019 Lu. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController<VM: GenericViewModel>: UIViewController, GenericViewController {
    
    var disposeBag: DisposeBag! = DisposeBag()
    var viewModel: VM
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewState.accept(.willAppear)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewState.accept(.didAppear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewState.accept(.willDisappear)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewState.accept(.didDisappear)
    }
    
    func initialize() {}
    
    func bindViewAndViewModel() {}

    func destroy() {
        viewModel.destroy()
        disposeBag = nil
    }
    
    // MARK: - Private

    private func binding() {
        disposeBag = DisposeBag()
        viewModel.disposeBag = DisposeBag()
        
        viewModel.react()
        bindViewAndViewModel()
    }
    
    deinit {
        print("Deinit", self)
    }
}
