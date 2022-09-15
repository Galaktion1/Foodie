//
//  MainViewViewModel.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 20.07.22.
//

import Foundation
import UIKit
import GoogleMaps
import CoreLocation


class MainViewViewModel {
    // MARK: - Closures for data set
    var reloadCollectionView: (() -> Void)?
    var setLocationManagerConfigurations: (() -> Void)?
    var getName: ((String) -> Void)?
    var logOutUser: (() -> Void)?
    
    private let globalQueue = DispatchQueue.global()
    
    // MARK: - Variables
    var allRestaurants = [Restaurant](){
        didSet {
            specialRestaurantsArray = allRestaurants
            setLocationManagerConfigurations?()
        }
    }
    
    var specialRestaurantsArray = [Restaurant]() {
        didSet {
            DispatchQueue.main.async {
                self.reloadCollectionView?()
            }
        }
    }
    
    private var firebaseManager = FirebaseManager()
    
    // MARK: - Funcs
    func fetchRestaurantsData() {
        RestaurantsNetworkManager.shared.apiService { [weak self] (result) in
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

    
    func getUsername() {
        firebaseManager.getUsername { [weak self] username in
            self?.getName?(username)
        }
    }
    
    func logOut() {
        firebaseManager.logoutUser { [weak self] in
            self?.logOutUser?()
        }
    }
    
    func getDistance(currentLocation: CLLocation) {
        for index in 0 ..< allRestaurants.count {
            let locationService = LocationService(coordinators: allRestaurants[index].descriptions.coordinates)
            allRestaurants[index].distance = locationService.getDistanceString(currentLocation: currentLocation)
        }
    }
    
    // MARK: - Functions for: all, nearby, fav and top restaurants sections.
    func setAllRestaurants() {
        specialRestaurantsArray = allRestaurants
    }
    
    
    func sortByNearby() {
        globalQueue.async {
            if let _ = self.allRestaurants.first?.distance {
                self.specialRestaurantsArray = (self.allRestaurants.sorted { Double($0.distance!)! < Double($1.distance!)! })
            }
        }
    }
    
    
    func setFavouriteRestaurants() {
        globalQueue.async {
            let favouriteRestaurantIds = UserDefaults.standard.array(forKey: "favRestaurantsIds") as? [Int] ?? []
            self.specialRestaurantsArray = self.specialRestaurantsArray.filter { favouriteRestaurantIds.contains($0.id) }
        }
    }
    
    
    func sortForTopAllRestaurants() {
        globalQueue.async {
            self.specialRestaurantsArray = self.allRestaurants.sorted { $0.rating > $1.rating }
        }
    }
    
    
    //MARK: - Functions for CollectionViews
    func numberOfItemsInSection() -> Int {
        specialRestaurantsArray.count
    }
    
    
    func restaurantsCellForRowAt(indexPath: IndexPath) -> Restaurant {
        specialRestaurantsArray[indexPath.row]
    }
    
    
    func getRestaurantImageURL(indexPath: IndexPath) -> String?  {
        specialRestaurantsArray[indexPath.row].restaurantImg
    }
    
    func foodsCellForItemAt(indexPath: IndexPath) -> Food? {
        specialRestaurantsArray[indexPath.row].foods?.first
    }
}

