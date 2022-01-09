//
//  TableContentProvider.swift
//  CityWiseAQI
//
//  Created by Vipul on 08/01/22.
//

import Foundation

import Foundation
import UIKit

public protocol TableViewEventHandler:class {
    func tableView(_ tableView: UITableView, didSelect cellModel:CellModelProtocol, at indexPath: IndexPath)
    func tableView(_ tableView: UITableView, didClickOnDelete cellModel:CellModelProtocol, at indexPath: IndexPath)
}

public extension TableViewEventHandler {
    func tableView(_ tableView: UITableView, didClickOnDelete cellModel:CellModelProtocol, at indexPath: IndexPath) {}
}

public protocol TableScrollViewDelegate:class {
    func tableViewDidScroll(_ tableView: UITableView)
}

open class TableContentProvider: NSObject, UITableViewDelegate, UITableViewDataSource {
    public weak var delegate:TableViewEventHandler?
    public weak var scrollViewDelegate:TableScrollViewDelegate?

    public var tableDataModel:TableViewModel
    
    public init(tableDataModel:TableViewModel) {
        self.tableDataModel = tableDataModel
    }
    
    // MARK: - Table view data source -
    open func numberOfSections(in tableView: UITableView) -> Int {
        return tableDataModel.sectionModels.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataModel.sectionModels[section].cellModels.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableDataModel.sectionModels[indexPath.section].cellModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.reuseIdentifier, for: indexPath)
        if let configurableView = cell as? ConfigurableView {
            configurableView.configure(cellModel)
        }
        return cell
    }
    
    // MARK: - Table view delegate -
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel = tableDataModel.sectionModels[indexPath.section].cellModels[indexPath.row]
        return cellModel.height
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let header = tableDataModel.sectionModels[section].header
        if Double(header?.height ?? 0.0) < 0.0 {
            return 0.001
        }
        
        return header?.height ?? 0.001
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let footer = tableDataModel.sectionModels[section].footer
        if Double(footer?.height ?? 0.0) < 0.0 {
            return 0.001
        }
        return footer?.height ?? 0.001
    }
    
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel = tableDataModel.sectionModels[indexPath.section].cellModels[indexPath.row]
        return cellModel.estimatedhHeight
    }
    
    open func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let header = tableDataModel.sectionModels[section].header
        return header?.estimatedhHeight ?? 1.1
    }
    
    open func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        let footer = tableDataModel.sectionModels[section].footer
        return footer?.estimatedhHeight ?? 1.1
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableDataModel.sectionModels[section].header
        if let reuseIdentifier = header?.reuseIdentifier , !reuseIdentifier.isEmpty {
            
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier)
            if let configurableView = view as? ConfigurableView {
                configurableView.configure(header!)
            }
            return view
        }
        return UIView()
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableDataModel.sectionModels[section].footer
        if let reuseIdentifier = footer?.reuseIdentifier , !reuseIdentifier.isEmpty {
            
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier)
            if let configurableView = view as? ConfigurableView {
                configurableView.configure(footer!)
            }
            return view
        }
        return UIView()
    }
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableDataModel.sectionModels[section].header?.title
    }
    
    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return tableDataModel.sectionModels[section].footer?.title
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = tableDataModel.sectionModels[indexPath.section].cellModels[indexPath.row]
        delegate?.tableView(tableView, didSelect: cellModel, at: indexPath)
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDelegate?.tableViewDidScroll(scrollView as! UITableView)
    }
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let cellModel = tableDataModel.sectionModels[indexPath.section].cellModels[indexPath.row]
        return cellModel.isDeleteOnSwipe
    }
    
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        let cellModel = tableDataModel.sectionModels[indexPath.section].cellModels[indexPath.row]
        guard cellModel.isDeleteOnSwipe else {
            return
        }
        delegate?.tableView(tableView, didClickOnDelete: cellModel, at: indexPath)
    }
}
