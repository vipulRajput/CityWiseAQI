//
//  AirQualityInfo.swift
//  CityWiseAQI
//
//  Created by Vipul on 08/01/22.
//

import Foundation

struct AirQualityInfo: Codable {
    
    let cityName: String
    let aqi: Double
    
    enum CodingKeys: String, CodingKey {
        case cityName = "city", aqi
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.cityName = try container.decodeIfPresent(String.self, forKey: .cityName) ?? ""
        self.aqi = try container.decodeIfPresent(Double.self, forKey: .aqi) ?? 1000
    }
}
