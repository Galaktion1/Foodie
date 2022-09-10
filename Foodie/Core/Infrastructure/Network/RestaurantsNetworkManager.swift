//
//  RestaurantsAPIManager.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 03.09.22.
//

import Foundation


// MARK: - Mock API Manager

class RestaurantsNetworkManager {
    
    static let shared = RestaurantsNetworkManager()
    
    private init() { }
    
    func apiService(completion: @escaping (Result<FetchedData, Error>) -> Void) {
        
        guard let url = URL(string: "https://run.mocky.io/v3/d41cdc66-dbad-48d8-9d9a-26b2c2d21949") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print("data fetch response is", response)
            }
            
            if let error = error {
                print("error while data fetch ->", error)
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(FetchedData.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(jsonData))
                    }
                }
                catch let error {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
}
