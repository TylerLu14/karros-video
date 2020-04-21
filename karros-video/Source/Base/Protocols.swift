//
//  Protocols.swift
//  cinemaxxi
//
//  Created by Hoang Lu on 10/31/19.
//  Copyright © 2019 Lu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol HasModel {
    associatedtype ModelElement: Equatable
    var model: ModelElement { get }
    init(model: ModelElement)
}

protocol Destroyable: class {
    var disposeBag: DisposeBag! { get set }
    func destroy()
}

protocol Reactable {
    func react()
}

protocol GenericViewModel: Destroyable, Reactable {
    var viewState: BehaviorRelay<ViewState> { get }
}

protocol GenericCellViewModel: Destroyable, Reactable, IdentifiableType, Equatable { }

protocol GenericListViewModel: GenericViewModel {
    associatedtype CellViewModelElement: GenericCellViewModel
    associatedtype SectionType: AnimatableSectionModelType where SectionType.Item == CellViewModelElement
    
    func getDataSource() -> Observable<[SectionType]>
    
    var selectedItem: PublishRelay<CellViewModelElement> { get }
    
    var deSelectedItem: PublishRelay<CellViewModelElement?> { get }
    var deSelectedIndex: PublishRelay<IndexPath?> { get }
    
    func itemSelected(_ indexPath: IndexPath)
    func itemDeselected(_ indexPath: IndexPath)
    
    func itemAt(_ indexPath: IndexPath) -> CellViewModelElement?
}

protocol GenericViewController: Destroyable {
    associatedtype ViewModelElement
    var viewModel: ViewModelElement { get set }
    
    func initialize()
    func bindViewAndViewModel()
}

protocol GenericTableViewController: GenericViewController {
    var tableView: UITableView { get }
}

protocol GenericCollectionController: GenericViewController {
    var collectionView: UICollectionView! { get }
    var layout: UICollectionViewLayout! { get }
}

protocol GenericCell: Destroyable {
    associatedtype ViewModelElement
    var viewModel: ViewModelElement! { get set }
}
