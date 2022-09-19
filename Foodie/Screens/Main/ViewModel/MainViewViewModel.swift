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


protocol FirebaseHelperProtocol {
    func getUsername()
    var getName: ((String) -> Void)? { get set }
    
    func logOut()
    var logOutUser: (() -> Void)? { get set }
}

protocol CollectionViewHelperProtocol {
    var numberOfItemsInSection: Int { get }
    func restaurantsCellForRowAt(indexPath: IndexPath) -> Restaurant
    func getRestaurantImageURL(indexPath: IndexPath) -> String?
    func foodsCellForItemAt(indexPath: IndexPath) -> Food?
}

protocol MapsHelperProtocol {
    func getDistance(currentLocation: CLLocation)
    var setLocationManagerConfigurations: (() -> Void)? { get set }
}

protocol MainViewUIChangesResponsibleProtocol {
    func setCollectionViewContent(about criterion: RestaurantCriterions)
    var reloadCollectionView: (() -> Void)? { get set }
    func searchRestaurant(text: String?) -> Bool
}

protocol MainViewViewModelProtocol: FirebaseHelperProtocol, MapsHelperProtocol, MainViewUIChangesResponsibleProtocol {
    func getRestaurants()
    init(with restaurantManager: RestaurantManagerProtocol)
}

final class MainViewViewModel: MainViewViewModelProtocol {
    
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
    private var restaurantsManager: RestaurantManagerProtocol
    
    init(with restaurantManager: RestaurantManagerProtocol) {
        self.restaurantsManager = restaurantManager
    }
    
    // MARK: - Funcs
    func getRestaurants() {
        Task {
            do {
                let fetchedData = try await restaurantsManager.fetchRestaurantsData()
                guard let restaurants = fetchedData.restaurants else { return }
                
                DispatchQueue.main.async { [weak self] in
                    self?.allRestaurants = restaurants
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func setCollectionViewContent(about criterion: RestaurantCriterions) {
        switch criterion {
        case .all:
            setAllRestaurants()
        case .nearby:
            sortByNearby()
        case .favourite:
            setFavouriteRestaurants()
        case .top:
            sortForTopAllRestaurants()
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
    private func setAllRestaurants() {
        specialRestaurantsArray = allRestaurants
    }
    
    private func sortByNearby() {
        globalQueue.async {
            if let _ = self.allRestaurants.first?.distance {
                self.specialRestaurantsArray = (self.allRestaurants.sorted { Double($0.distance!)! < Double($1.distance!)! })
            }
        }
    }
    
    private func setFavouriteRestaurants() {
        globalQueue.async {
            let favouriteRestaurantIds = UserDefaults.standard.array(forKey: "favRestaurantsIds") as? [Int] ?? []
            self.specialRestaurantsArray = self.specialRestaurantsArray.filter { favouriteRestaurantIds.contains($0.id) }
        }
    }
    
    private func sortForTopAllRestaurants() {
        globalQueue.async {
            self.specialRestaurantsArray = self.allRestaurants.sorted { $0.rating > $1.rating }
        }
    }
}


//MARK: - Extension For Functions Of CollectionView
extension MainViewViewModel: CollectionViewHelperProtocol {
    var numberOfItemsInSection: Int {
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


// MARK: - Extension For TextField Delegate Function
extension MainViewViewModel {
    func searchRestaurant(text: String?) -> Bool {
        var filtered = [Restaurant]()
        guard let charactersCount = text?.count else { return false }

        if charactersCount != 0 {
            filtered.removeAll()
            for each in specialRestaurantsArray {
                let range = each.name.lowercased().range(of: text ?? "", options: .caseInsensitive, range: nil, locale: nil)
                if range != nil {
                    filtered.append(each)
                }
            }
            specialRestaurantsArray = filtered
        }
        return true
    }
}
