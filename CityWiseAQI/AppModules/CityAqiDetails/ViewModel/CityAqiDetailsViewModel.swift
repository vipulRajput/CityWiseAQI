//
//  CityAqiDetailsViewModel.swift
//  CityWiseAQI
//
//  Created by Vipul on 09/01/22.
//

import Foundation
import Charts
import UIKit

class CityAqiDetailsViewModel: BaseViewModel {
    
    var city: City
    var updateChart:((LineChartData, IndexAxisValueFormatter)-> Void)?
    
    init(city: City) {
        
        self.city = city
        super.init()
    }
    
    func buildChartData() {
        
        var chartEntries = [ChartDataEntry]()
        for (index, aqi) in self.city.past30SecAqiRecords.enumerated() {
            chartEntries.append(ChartDataEntry(x: Double(index), y: aqi.currentValue))
        }
        
        let line = LineChartDataSet(entries: chartEntries, label: "AQI with 30 secs interval")
        line.circleColors = self.city.past30SecAqiRecords.map({ $0.level.getColor() })
        line.lineWidth = 2
        line.circleRadius = 4
        line.colors = [.systemBlue]
        
        let timeSlots = self.city.past30SecAqiRecords.map({ $0.recordTime.convertDateFormatter_h_mm_a() })
        let xAxisValues = IndexAxisValueFormatter(values: timeSlots)
        self.updateChart?(LineChartData(dataSet: line), xAxisValues)
    }
}

extension CityAqiDetailsViewModel: CityAqiDetailsDelegate {
    
    func updateCity(with aqi: AQI) {
                
        if self.city.past30SecAqiRecords.count > 25 {
            self.city.past30SecAqiRecords.removeFirst()
        }
        
        let differenceInSeconds = self.city.past30SecAqiRecords.count <= 1 ? 30 : Int(Date().timeIntervalSince(self.city.past30SecAqiRecords.last!.recordTime))
        if differenceInSeconds >= 30 {
            self.city.past30SecAqiRecords.append(aqi)
            self.buildChartData()
        }
    }
}
