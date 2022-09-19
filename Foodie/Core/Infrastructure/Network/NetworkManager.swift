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
        guard let url = URL(string: "https://run.mocky.io/v3/d41cdc66-dbad-48d8-9d9a-26b2c2d21949") else { throw ApiError.invalidUrl }
        
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


