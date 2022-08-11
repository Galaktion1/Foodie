//
//  MainViewViewModel.swift
//  Galaktion Nizharadze, Assignment #14
//
//  Created by Gaga Nizharadze on 20.07.22.
//

import Foundation
import UIKit

class MainViewViewModel {
    
    var reloadCollectionView: (()->Void)?
    var allRestaurants = [Restaurant](){
        didSet {
            specialRestaurantsArray = allRestaurants
        }
    }
    
    var specialRestaurantsArray = [Restaurant]() {
        didSet {
            self.reloadCollectionView?()
        }
    }
    
    
    private func apiService(completion: @escaping (Result<FetchedData, Error>) -> Void) {
        
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
    
    
    
    func fetchRestaurantsData() {
        apiService { [weak self] (result) in
            switch result {
                
            case .success(let listOf):
                print("succesful retrived data")
                guard let data = listOf.restaurants else { return }
                self?.allRestaurants = data
            case .failure(let error):
                print("error processing json data \(error)")
            }
        }
    }
    

    
    func setFavouriteRestaurants() {
        let favouriteRestaurantIds = UserDefaults.standard.array(forKey: "favRestaurantsIds") as? [Int] ?? []
        specialRestaurantsArray = specialRestaurantsArray.filter { favouriteRestaurantIds.contains($0.id!) }
    }
    
    func setAllRestaurants() {
        specialRestaurantsArray = allRestaurants
    }
    func setTopAllRestaurants() {
        specialRestaurantsArray = allRestaurants.sorted { $0.rating! < $1.rating! }
    }
    
    func numberOfItemsInSection() -> Int {
        specialRestaurantsArray.count
    }
    
    func restaurantsCellForRowAt (indexPath: IndexPath) -> Restaurant {
        let taskData = specialRestaurantsArray[indexPath.row]
       
        return taskData
    }
    
    func restaurantImage(imgView: UIImageView, indexPath: IndexPath)  {
        guard let url = specialRestaurantsArray[indexPath.row].restaurantImg else { return }
        imgView.loadImageUsingCache(withUrl: url)
    }
    
    
    func foodsCellForItemAt(indexPath: IndexPath) -> Food? {
        let data = specialRestaurantsArray[indexPath.row].foods?.first
        
        return data
    }
    
    
    
    
    func moveActiveIndicatorView(mainButton: UIButton, button2: UIButton, button3: UIButton, button4: UIButton, indicatorView: UIView) {
        mainButton.tintColor = UIColor(named: "specialOrange")
        button2.tintColor = .systemGray
        button3.tintColor = .systemGray
        button4.tintColor = .systemGray
        
        let xCoordinant = mainButton.frame.origin.x
        let mainButtonWidth = mainButton.frame.width
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options:[], animations: {
            indicatorView.transform = CGAffineTransform(translationX: xCoordinant, y: 0)
            indicatorView.frame.size.width = mainButtonWidth
            }, completion: nil)
    }

}
