//
//  BaseTableViewController.swift
//  cinemaxxi
//
//  Created by Hoang Lu on 10/31/19.
//  Copyright © 2019 Lu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class BaseTableCell<VM: GenericCellViewModel>: UITableViewCell, GenericCell {
    
    typealias ViewModelElement = VM
    
    var viewModel: VM!{
        didSet { resetBinding() }
    }
    var disposeBag: DisposeBag! = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        destroy()
    }
    
    private func setup() {
        backgroundColor = .clear
        layoutMargins = .zero
        preservesSuperviewLayoutMargins = false
        
        initialize()
    }
    
    func resetBinding() {
        disposeBag = DisposeBag()
        self.viewModel?.disposeBag = DisposeBag()
        
        self.viewModel?.react()
        bindViewAndViewModel()
    }
    
    func destroy() {
        disposeBag = nil
        viewModel?.disposeBag = nil
    }
    
    func initialize() {}
    func bindViewAndViewModel() {}
}

class BaseTableViewController<VM: GenericListViewModel>: BaseViewController<VM>, GenericTableViewController, UITableViewDelegate {

    typealias CVM = VM.CellViewModelElement
    typealias TableDataSourceType = TableViewSectionedDataSource<VM.SectionType>
    
    var tableViewStyle: UITableView.Style {
        return .plain
    }
    
    private var _tableView: UITableView?
    var tableView: UITableView {
        guard let tableView = self._tableView else {
            self._tableView = UITableView(frame: .zero, style: tableViewStyle)
            return self._tableView!
        }
        return tableView
    }
    
    open override func initialize() {
        super.initialize()
        
        tableView.indicatorStyle = .white
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 170
        tableView.isExclusiveTouch = true
        
        view.addSubview(tableView)
    }
    
    open override func bindViewAndViewModel() {
        super.bindViewAndViewModel()
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let animationConfig = AnimationConfiguration(
            insertAnimation: .fade,
            reloadAnimation: .fade,
            deleteAnimation: .fade
        )
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<VM.SectionType>(
            animationConfiguration: animationConfig,
            configureCell: { [weak self] in (self?.configureCell($0, tableView: $1, indexPath: $2, cellViewModel: $3) ?? UITableViewCell()) },
            titleForHeaderInSection: { [weak self] in self?.titleForFooterInSection($0, indexSection: $1) },
            titleForFooterInSection: { [weak self] in self?.titleForFooterInSection($0, indexSection: $1) },
            canEditRowAtIndexPath: { [weak self] in (self?.canEditRowAtIndexPath($0, indexPath: $1) ?? true) }
        )
        
        viewModel.getDataSource()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [viewModel] index in viewModel.itemSelected(index) })
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeselected
            .subscribe(onNext: { [viewModel] index in viewModel.itemDeselected(index) })
            .disposed(by: disposeBag)
    }
    
    open func cellIdentifier(_ cellViewModel: CVM) -> String {
        return "Cell"
    }
    
    open func configureCell(_ dataSource: TableDataSourceType, tableView: UITableView, indexPath: IndexPath, cellViewModel: CVM) -> UITableViewCell {
        let identifier = cellIdentifier(cellViewModel)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! BaseTableCell<CVM>
        cell.viewModel = cellViewModel
        return cell
    }
    
    open func titleForHeaderInSection(_ dataSource: TableDataSourceType, indexSection: Int) -> String? {
        return nil
    }
    
    open func titleForFooterInSection(_ dataSource: TableDataSourceType, indexSection: Int) -> String? {
        return nil
    }
    
    open func canEditRowAtIndexPath(_ dataSource: TableDataSourceType, indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - Table view factories
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    open func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
