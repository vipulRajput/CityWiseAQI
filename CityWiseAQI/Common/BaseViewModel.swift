//
//  BaseViewModel.swift
//  CityWiseAQI
//
//  Created by Vipul on 08/01/22.
//

import Foundation
import UIKit

protocol ContentLoadingProtocol {
    var endLoadingAnimation : (()->Void)? {get set}
    var beginLoadingAnimation : (()->Void)? {get set}
}
protocol TableViewCompliantViewModel : ContentLoadingProtocol {
    
    var footerCellModel:CellModelProtocol? {get set}
    var headerCellModel:CellModelProtocol? {get set}
    var cellModel : [CellModelProtocol] {get set}
    
    func buildTableViewModels()
    func numberOfSections() -> Int
    func tableView(numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    
    func heightForHeaderInSection(section: Int) -> CGFloat
    func heightForFooterInSection( section: Int) -> CGFloat
    func estimatedHeightForFooterInSection( section: Int) -> CGFloat
    func estimatedHeightForHeaderInSection( section: Int) -> CGFloat
}

class BaseViewModel : NSObject {
    
    var backTapped : (()->Void)?
    var authExpiredHandler : (()->Void)?
    var continuefooterToggled : ((Int,CellModelProtocol?)->Void)?
    var dataSourceUpdated : (()->Void)?
    var cellModel : [CellModelProtocol] = []
    
    var headerCellModel : CellModelProtocol?
    var footerCellModel : CellModelProtocol?
    
    var endLoadingAnimation: (() -> Void)?
    var beginLoadingAnimation: (() -> Void)?
  
    override init() {
        super.init()
        self.initializeModelAndValidators()
        self.initializeHeaderAndFooterCellModels()
        self.buildTableViewModels()
        self.registerForObservers()
    }
    func registerForObservers() {
    }
    func initializeModelAndValidators() {
    }
    func initializeHeaderAndFooterCellModels() {
    }
    
    func buildTableViewModels() {
    }

    func numberOfSections() -> Int {
        return 1
    }
    func tableView(numberOfRowsInSection section: Int) -> Int {
        return cellModel.count
    }
    func heightForHeaderInSection(section: Int) -> CGFloat {
        return headerCellModel?.height ?? 0.0
    }
    func heightForFooterInSection( section: Int) -> CGFloat {
        return footerCellModel?.height ?? 0.0
    }
    func estimatedHeightForFooterInSection( section: Int) -> CGFloat {
        return footerCellModel?.estimatedhHeight ?? 0.0
    }
    func estimatedHeightForHeaderInSection( section: Int) -> CGFloat {
        return headerCellModel?.estimatedhHeight ?? 0.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = cellModel[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: model.reuseIdentifier)
        (cell as? ConfigurableView)?.configure(model)
        return cell!
    }
    
    func toggleContinueFooterCell(_ newValue : Bool) {
//        guard let cellModel = self.footerCellModel as? NGContinueFooterCellModel , newValue != cellModel.isEnabled else {
//            return
//        }
//        cellModel.isEnabled = newValue
//        self.continuefooterToggled?(0,self.footerCellModel)
    }
}

