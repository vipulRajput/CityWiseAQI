//
//  BaseTableViewCell.swift
//  CityWiseAQI
//
//  Created by Vipul on 08/01/22.
//

import Foundation
import UIKit

class BaseTableViewCell: UITableViewCell , NibLoadableView,ConfigurableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func configure(_ cellModel:CellModelProtocol) {
        
    }
}

