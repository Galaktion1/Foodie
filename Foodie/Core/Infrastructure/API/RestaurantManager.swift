//
//  RestaurantManager.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 19.09.22.
//

import Foundation

protocol RestaurantManagerProtocol {
    func fetchRestaurantsData()  async throws -> FetchedData
}

class RestaurantManager: RestaurantManagerProtocol {
    
    func fetchRestaurantsData()  async throws -> FetchedData {
        try await NetworkManager.shared.fetchRestaurants(decodingType: FetchedData.self)
    }
}
