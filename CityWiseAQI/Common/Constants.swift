//
//  Constants.swift
//  CityWiseAQI
//
//  Created by Vipul on 08/01/22.
//

import Foundation
import UIKit

struct Constants {
    
    static let serverURL = "ws://city-ws.herokuapp.com/"
    static let commonErrorMsg = "Oops something went wrong"
}

struct AQILabelColors {
    
    static let good = #colorLiteral(red: 0.4156862745, green: 0.6470588235, blue: 0.3529411765, alpha: 1)
    static let satisfactory = #colorLiteral(red: 0.6352941176, green: 0.7411764706, blue: 0.3764705882, alpha: 1)
    static let moderate = #colorLiteral(red: 1, green: 0.9732789397, blue: 0.3849527538, alpha: 1)
    static let poor = #colorLiteral(red: 0.8901960784, green: 0.6156862745, blue: 0.2862745098, alpha: 1)
    static let veryPoor = #colorLiteral(red: 0.8431372549, green: 0.3019607843, blue: 0.2431372549, alpha: 1)
    static let severe = #colorLiteral(red: 0.631372549, green: 0.2196078431, blue: 0.1725490196, alpha: 1)
    static let unknown = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
}
