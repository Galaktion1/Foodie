//
//  Double + Extension.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 10.09.22.
//

import Foundation

extension Double {
    func format() -> String {
        return String(format: "%.1f", self)
    }
    
    func visualizeRating() -> String {
        let circles = Int(self / 2)
        let circleString = String(repeating: "🔴", count: circles)
        let emptyCircleString = String(repeating: "⭕️", count: 5 - circles)
        let visualizedRating = circleString + emptyCircleString
        
        return visualizedRating
    }
}
