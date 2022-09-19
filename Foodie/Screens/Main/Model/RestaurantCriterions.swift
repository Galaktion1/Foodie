//
//  RestaurantCriterions.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 20.09.22.
//

import Foundation

enum RestaurantCriterions: String, CaseIterable {
    case all
    case nearby
    case favourite
    case top
    
    var displayName: String {
        rawValue.capitalized
    }
}
