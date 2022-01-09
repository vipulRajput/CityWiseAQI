//
//  AQI.swift
//  CityWiseAQI
//
//  Created by Vipul on 08/01/22.
//

import Foundation

struct AQI {
    
    let currentValue: Double
    let level: AQILevel
    let recordTime: Date

    init(info: AirQualityInfo) {
        
        currentValue = info.aqi
        level = AQILevel.getAqiLabel(for: info.aqi)
        recordTime = Date()
    }
}
