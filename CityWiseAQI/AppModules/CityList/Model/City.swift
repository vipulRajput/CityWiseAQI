//
//  City.swift
//  CityWiseAQI
//
//  Created by Vipul on 08/01/22.
//

import Foundation

struct City {
    
    let name: String
    var currentAQI: String
    var level: AQILevel
    var recordTime: Date
    var past30SecAqiRecords = [AQI]()
    
    init(info: AirQualityInfo) {
        
        self.name = info.cityName
        self.currentAQI = String(format: "%.1f", info.aqi)
        self.level = AQILevel.getAqiLabel(for: info.aqi)
        self.recordTime = Date()
    }
        
    mutating func updateCity(info: AirQualityInfo) {
        
        self.currentAQI = String(format: "%.1f", info.aqi)
        self.level = AQILevel.getAqiLabel(for: info.aqi)
        self.recordTime = Date()
    }
}
