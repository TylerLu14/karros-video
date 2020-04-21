//
//  BaseCollectionViewController.swift
//  cinemaxxi
//
//  Created by Hoang Lu on 10/31/19.
//  Copyright © 2019 Lu. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class BaseCollectionCell<VM: GenericCellViewModel>: UICollectionViewCell {
    
    typealias ViewModelElement = VM
    
    var disposeBag: DisposeBag! = DisposeBag()
    var viewModel: VM! {
        didSet { resetBinding() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        destroy()
    }
    
    private func setup() {
        backgroundColor = .clear
        initialize()
    }
    
    private func resetBinding() {
        disposeBag = DisposeBag()
        viewModel?.disposeBag = DisposeBag()
        
        viewModel?.react()
        bindViewAndViewModel()
    }
    
    func destroy() {
        disposeBag = nil
        viewModel?.disposeBag = nil
    }
    
    func initialize() {
        clipsToBounds = true
    }
    func bindViewAndViewModel() {}
}

class BaseCollectionHeader: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        backgroundColor = .clear
        initialize()
    }
    
    func initialize() {
        clipsToBounds = true
    }
}

class BaseCollectionViewController<VM: GenericListViewModel>: BaseViewController<VM>, GenericCollectionController, UICollectionViewDelegate {
    
    typealias CVM = VM.CellViewModelElement
    typealias SectionType = VM.SectionType
    typealias CollectionDataSourceType = CollectionViewSectionedDataSource<VM.SectionType>
    
    var collectionView: UICollectionView!
    var layout: UICollectionViewLayout!
    
    func setupLayout() {
        layout = UICollectionViewFlowLayout()
    }
       
    override func viewDidLoad() {
        setupLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        super.viewDidLoad()
    }
    
    override func initialize() {
        super.initialize()
        view.addSubview(collectionView)
    }
    
    override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let animationConfig = AnimationConfiguration(
            insertAnimation: .automatic,
            reloadAnimation: .automatic,
            deleteAnimation: .automatic
        )
        
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<VM.SectionType>(
            animationConfiguration: animationConfig,
            configureCell: { [unowned self] in self.configureCell($0, collectionView: $1, indexPath: $2, cellViewModel: $3) },
            configureSupplementaryView: { [unowned self] in self.configureSupplementaryView($0, collectionView: $1, kind: $2, indexPath: $3) }
        )
        
        viewModel.getDataSource()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [viewModel] index in viewModel.itemSelected(index) })
            .disposed(by: disposeBag)
        
        collectionView.rx.itemDeselected
            .subscribe(onNext: { [viewModel] index in viewModel.itemDeselected(index) })
            .disposed(by: disposeBag)
    }
    
    func cellIdentifier(_ cellViewModel: CVM) -> String {
        return "Cell"
    }
    
    func supplementIdentifier(_ section: Int) -> String {
        return "Supplement"
    }
    
    func configureCell(_ dataSource: CollectionDataSourceType, collectionView: UICollectionView, indexPath: IndexPath, cellViewModel: CVM) -> UICollectionViewCell {
        let identifier = cellIdentifier(cellViewModel)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! BaseCollectionCell<CVM>
        cell.viewModel = cellViewModel
        return cell
    }
    
    func configureSupplementaryView(_ dataSource: CollectionDataSourceType, collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView(frame: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) { }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) { }
}
