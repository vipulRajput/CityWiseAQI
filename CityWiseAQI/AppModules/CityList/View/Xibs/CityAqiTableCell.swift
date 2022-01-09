//
//  CityAqiTableCell.swift
//  CityWiseAQI
//
//  Created by Vipul on 07/01/22.
//

import UIKit

class CityAqiTableCellViewModel: CellModel {
    
    let city: City
    
    init(city: City) {
        
        self.city = city
        super.init(reuseIdentifier: CityAqiTableCell.identifier, estimatedhHeight: 110)
    }
}

class CityAqiTableCell: BaseTableViewCell {

    @IBOutlet weak var faceIconLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        self.bgView.clipsToBounds = true
        self.bgView.layer.cornerRadius = 5
        self.faceIconLabel.clipsToBounds = true
        self.faceIconLabel.layer.cornerRadius = self.faceIconLabel.frame.height / 2
    }
    
    override func configure(_ cellModel: CellModelProtocol) {
        
        guard let cVM = cellModel as? CityAqiTableCellViewModel else {
            return
        }
        
        self.cityNameLabel.text = cVM.city.name
        self.statusLabel.text = cVM.city.level.getDesc()
        self.aqiLabel.text = cVM.city.currentAQI
        self.lastUpdatedLabel.text = cVM.city.recordTime.timeAgoDisplay()
        self.faceIconLabel.text = cVM.city.level.getFace()
        self.faceIconLabel.backgroundColor = cVM.city.level.getColor()
        self.indicatorView.backgroundColor = cVM.city.level.getColor()
    }
}
