//
//  RestaurantsAPIManager.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 03.09.22.
//

import Foundation


// MARK: - Mock API Manager

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func apiService(completion: @escaping (Result<FetchedData, Error>) -> Void) {
        
        guard let url = URL(string: "https://run.mocky.io/v3/33a78899-3c38-428c-8460-7d800d94f413") else { return }
        
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
