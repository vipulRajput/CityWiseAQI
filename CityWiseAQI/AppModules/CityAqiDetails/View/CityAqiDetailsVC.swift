//
//  CityAqiDetailsVC.swift
//  CityWiseAQI
//
//  Created by Vipul on 09/01/22.
//

import UIKit
import Charts

class CityAqiDetailsVC: BaseViewController {

    @IBOutlet weak var aqiChart: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
}

extension CityAqiDetailsVC {
    
    private func updateTitle(with cityName: String) {
        self.title = cityName
    }
    
    private func initialSetup() {
        
        self.aqiChart.chartDescription.text = "live"
        self.aqiChart.chartDescription.textColor = .systemRed
        self.aqiChart.pinchZoomEnabled = true
        self.aqiChart.dragEnabled = true
        self.aqiChart.setScaleEnabled(true)
        self.aqiChart.leftAxis.xOffset = 12
        self.aqiChart.leftAxis.axisMinimum = 0
        self.aqiChart.leftAxis.axisMaximum = 500
        self.aqiChart.leftAxis.gridLineDashLengths = [4, 6]
        self.aqiChart.xAxis.drawGridLinesEnabled = false
        self.aqiChart.xAxis.labelRotationAngle = -50
        self.aqiChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        self.aqiChart.rightAxis.enabled = false
        
        self.setupVM()
    }
    
    private func setupVM() {
        
        guard let vm = self.viewModel as? CityAqiDetailsViewModel else { return }
        vm.updateChart = { [weak self] (dataSet, xAxisValues) in            
            self?.aqiChart.data = dataSet
            self?.aqiChart.xAxis.valueFormatter = xAxisValues
            self?.aqiChart.notifyDataSetChanged()
        }
        vm.buildChartData()
        self.updateTitle(with: vm.city.name)
    }
}
