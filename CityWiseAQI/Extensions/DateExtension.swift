//
//  DateExtension.swift
//  CityWiseAQI
//
//  Created by Vipul on 08/01/22.
//

import Foundation

extension Date {
    
    func timeAgoDisplay() -> String {
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let timeAgo = formatter.localizedString(for: self, relativeTo: Date())
        return timeAgo.prefix(2) == "in" ? "Just now" : timeAgo
    }
    
    func convertDateFormatter_h_mm_a() -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self)
    }
}
