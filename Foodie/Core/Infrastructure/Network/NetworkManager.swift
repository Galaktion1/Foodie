//
//  RestaurantsAPIManager.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 03.09.22.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() { }
    
    func fetchRestaurants<T: Decodable>(decodingType: T.Type) async throws ->T {
        let session = URLSession.shared
        let urlString = "https://run.mocky.io/v3/42db0b05-9626-41cd-b5a2-cfd5e232147d"
        guard let url = URL(string: urlString) else { throw ApiError.invalidUrl }
        
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else { throw ApiError.httpError }
        
        do {
            return try JSONDecoder().decode(decodingType.self, from: data)
        } catch {
            throw ApiError.decodingError
        }
    }
}


