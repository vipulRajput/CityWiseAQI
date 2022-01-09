//
//  AQILevel.swift
//  CityWiseAQI
//
//  Created by Vipul on 08/01/22.
//

import Foundation
import UIKit

enum AQILevel {
    
    case good
    case satisfactory
    case moderate
    case poor
    case veryPoor
    case severe
    case unknown
    
    static func getAqiLabel(for aqi: Double) -> AQILevel {
        
        switch aqi {
        
        case 0...51:
            return .good
        case 51...101:
            return .satisfactory
        case 101...201:
            return .moderate
        case 201...301:
            return .poor
        case 301...401:
            return .veryPoor
        case 401...501:
            return .severe
        default:
            return .unknown
        }
    }
    
    func getDesc() -> String {
        
        switch self {
        
        case .good:
            return "Good"
        case .satisfactory:
            return "Satisfactory"
        case .moderate:
            return "Moderate"
        case .poor:
            return "Poor"
        case .veryPoor:
            return "Very Poor"
        case .severe:
            return "Severe"
        case .unknown:
            return "Unknown"
        }
    }
    
    func getColor() -> UIColor {
        
        switch self {
        
        case .good:
            return AQILabelColors.good
        case .satisfactory:
            return AQILabelColors.satisfactory
        case .moderate:
            return AQILabelColors.moderate
        case .poor:
            return AQILabelColors.poor
        case .veryPoor:
            return AQILabelColors.veryPoor
        case .severe:
            return AQILabelColors.severe
        case .unknown:
            return AQILabelColors.unknown
        }
    }
    
    func getFace() -> String {
        
//        utilityicon
        switch self {
        
        case .good:
            return "a"
        case .satisfactory:
            return "b"
        case .moderate:
            return "c"
        case .poor:
            return "d"
        case .veryPoor:
            return "e"
        case .severe:
            return "f"
        case .unknown:
            return ""
        }
    }
}
