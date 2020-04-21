//
//  ListViewModel.swift
//  cinemaxxi
//
//  Created by Hoang Lu on 10/31/19.
//  Copyright © 2019 Lu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class ListViewModel<CVM: GenericCellViewModel & Hashable>: BaseViewModel, GenericListViewModel {

    typealias CellViewModelElement = CVM
    typealias SectionType = AnimatableSectionModel<String, CVM>
    typealias ItemsSourceType = [SectionType]
    
    let itemsSource = BehaviorRelay<[SectionType]>(value: [])
    
    let selectedItem = PublishRelay<CellViewModelElement>()
    var selectedIndex = PublishRelay<IndexPath?>()
    
    let deSelectedItem = PublishRelay<CellViewModelElement?>()
    var deSelectedIndex = PublishRelay<IndexPath?>()
    
    func getDataSource() -> Observable<[AnimatableSectionModel<String, CVM>]> {
        itemsSource.asObservable()
    }
       
    func itemSelected(_ indexPath: IndexPath) {
        guard let cvm = itemAt(indexPath) else { return }
        
        selectedItemWillChange(cvm)
        selectedItem.accept(cvm)
        selectedIndex.accept(indexPath)
        selectedItemDidChange(cvm)
    }
    
    func itemDeselected(_ indexPath: IndexPath) {
        guard let cvm = itemAt(indexPath) else { return }
        
        deSelectedItem.accept(cvm)
        deSelectedIndex.accept(indexPath)
    }
    
    open func selectedItemWillChange(_ cellViewModel: CVM) {}
    
    open func selectedItemDidChange(_ cellViewModel: CVM) {}
    
    public func itemAt(row: Int, section: Int = 0) -> CVM? {
        return itemsSource.value[safe: section]?.items[safe: row]
    }
    
    func itemAt(_ indexPath: IndexPath) -> CVM? {
        return itemAt(row: indexPath.row, section: indexPath.section)
    }
    
    func sectionAt(_ section: Int) -> SectionType? {
        return itemsSource.value[safe: section]
    }
    
    func firstCVM(where: (CVM) -> Bool) -> CVM? {
        return itemsSource.value
            .flatMap{ section in section.items }
            .first(where: `where`)
    }
    
    func makeSources(_ items: [CVM]) -> ItemsSourceType {
        return [AnimatableSectionModel(model: "", items: items)]
    }
    
    func appendItems(_ items: [CVM], toSection sectionIndex: Int = 0) {
        var currentSource = itemsSource.value
        
        if var section = sectionAt(sectionIndex) {
            section.items.append(contentsOf: items)
            currentSource[sectionIndex] = section
            itemsSource.accept(currentSource)
        } else {
            let newSection = AnimatableSectionModel(model: "", items: items)
            itemsSource.accept(currentSource + [newSection])
        }
    }
    
    func appendSections(_ sections: [SectionType]) {
        var currentSource = itemsSource.value
        currentSource.append(contentsOf: sections)
        itemsSource.accept(currentSource)
    }
}

extension ListViewModel where CVM: HasModel {
    
    func transformResponses<T: HasModel, M>(_ responses: [M]?) -> [T] where T.ModelElement == M {
        guard let responses = responses else { return [T]() }
        return responses.flatMap { [T(model: $0)] }
    }
    
    func makeSources(_ items: [String:[CVM.ModelElement]]) -> ItemsSourceType {
        return items.map { group in
            let cvms = transformResponses(group.value) as [CVM]
            return AnimatableSectionModel(model: group.key, items: cvms)
        }
    }
    
    func makeSources(_ items: [[CVM.ModelElement]]) -> ItemsSourceType {
        return items.map { AnimatableSectionModel(model: "", items: transformResponses($0)) }
    }
    
    func makeSources(_ items: [CVM.ModelElement]) -> ItemsSourceType {
        return [AnimatableSectionModel(model: "", items: transformResponses(items))]
    }
}
