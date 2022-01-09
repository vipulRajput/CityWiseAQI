//
//  TableViewModel.swift
//  CityWiseAQI
//
//  Created by Vipul on 08/01/22.
//

import Foundation
import UIKit

// MARK: - CellModel -
open class CellModel:CellModelProtocol {
    public var reuseIdentifier: String
    public var height: CGFloat
    public var estimatedhHeight: CGFloat
    public var isSectionLastCell = false
    public var isSectionFirstCell = false
    public var isDeleteOnSwipe = false
    
    public init(reuseIdentifier:String, height:CGFloat = UITableView.automaticDimension, estimatedhHeight:CGFloat) {
        self.reuseIdentifier = reuseIdentifier
        self.height = height
        self.estimatedhHeight = estimatedhHeight
    }
}

// MARK: - SupplementaryViewModel -
open class SupplementaryViewModel:CellModel {
    public var title: String?
}

// MARK: - SectionModel -
open class SectionModel {
    
    public var header:SupplementaryViewModel?
    public var footer:SupplementaryViewModel?
    
    public var sectionIdentifier:String?
    public var cellModels = [CellModelProtocol]()
    
    public init() {
    }
    
    public func removeAll(from index:Int = 0) {
        if index == 0 {
            cellModels.removeAll()
        } else {
            for _ in index...(cellModels.count - 1) {
                cellModels.remove(at: index)
            }
        }
    }
    
    public func removeCell(at index: Int) {
        cellModels.remove(at: index)
    }
    
    public func removeLast() {
        cellModels.removeLast()
    }
    
    public func add(cellModel: CellModelProtocol, at index: Int) {
        if index <= self.cellModels.count {
            cellModels.insert(cellModel, at: index)
        } else {
            cellModels.append(cellModel)
        }
    }
    
    public func add(cellModel: CellModelProtocol) {
        cellModels.append(cellModel)
    }
    
    public func add(cellModels newCellModels: [CellModelProtocol]) {
        cellModels += newCellModels
    }
}

// MARK: - TableViewModel -
open class TableViewModel {
    public var sectionModels = [SectionModel]()
    
    public init(){
    }
    
    public func lastSectionModel() -> SectionModel? {
        return sectionModels.last
    }
    
    public func indexOf(section sectionModel: SectionModel) -> Int? {
        return sectionModels.index { (_section) -> Bool in return _section === sectionModel }
    }
    
    public func sectionModel(with sectionIdentifier: String) -> SectionModel? {
        return sectionModels.filter { (section) -> Bool in return section.sectionIdentifier == sectionIdentifier }.first
    }
    
    public func sectionModel(at index: Int) -> SectionModel? {
        if index < sectionModels.count {
            return sectionModels[index]
        }
        return nil
    }
    
    public func cellModel(at indexPath: IndexPath) -> CellModelProtocol {
        return sectionModels[indexPath.section].cellModels[indexPath.row]
    }
    public func cellModels(in section: Int) -> [CellModelProtocol] {
        return sectionModels[section].cellModels
    }
    
    // MARK: - Adding section models -
    public func insertSectionModel() -> SectionModel {
        let newSectionModel = SectionModel()
        sectionModels.append(newSectionModel)
        return newSectionModel
    }
    
    public func insertSectionModel(with cellModel: CellModelProtocol) -> SectionModel {
        let newSectionModel = insertSectionModel()
        newSectionModel.add(cellModel: cellModel)
        return newSectionModel
    }
    
    public func insertSectionModel(with cellModels: [CellModelProtocol]) -> SectionModel {
        let newSectionModel = insertSectionModel()
        newSectionModel.add(cellModels:cellModels)
        return newSectionModel
    }
    
    public func add(sectionModel: SectionModel) {
        sectionModels.append(sectionModel)
    }
    
    // MARK: - Adding cell models -
    public func add(cellModel: CellModelProtocol) {
        let section:SectionModel
        if let s = lastSectionModel() {
            section = s
        } else {
            section = insertSectionModel()
        }
        section.add(cellModel: cellModel)
    }
    
    public func add(cellModel: CellModelProtocol, toLastSectionAt index: Int) {
        let section = sectionModels[index]
        section.add(cellModel:cellModel)
    }
    
    // MARK: - Remove cell models -
    public func removeSection(at index: Int) {
        sectionModels.remove(at: index)
    }
    
    public func removeAll() {
        sectionModels.removeAll()
    }
    
    public func removeLast() {
        sectionModels.removeLast()
    }
}

