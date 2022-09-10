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
    
    // MARK: - Variables
    var allRestaurants = [Restaurant](){
        didSet {
            specialRestaurantsArray = allRestaurants
            setLocationManagerConfigurations?()
        }
    }
    
    var specialRestaurantsArray = [Restaurant]() {
        didSet {
            reloadCollectionView?()
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
    
    func getDistance(currentLocation: CLLocation) {
        for index in 0 ..< allRestaurants.count {
            let locationService = LocationService(coordinators: allRestaurants[index].descriptions.coordinates)
            allRestaurants[index].distance = locationService.getDistanceString(currentLocation: currentLocation)
        }
    }
    
    
    func setFavouriteRestaurants() {
        let favouriteRestaurantIds = UserDefaults.standard.array(forKey: "favRestaurantsIds") as? [Int] ?? []
        specialRestaurantsArray = specialRestaurantsArray.filter { favouriteRestaurantIds.contains($0.id) }
    }
    
    
    func setAllRestaurants() {
        specialRestaurantsArray = allRestaurants
    }
    
    
    func sortByTopAllRestaurants() {
        specialRestaurantsArray = allRestaurants.sorted { $0.rating > $1.rating }
    }
    
    func sortByNearby() {
        if let _ = allRestaurants.first?.distance {
            specialRestaurantsArray = allRestaurants.sorted { Double($0.distance!)! < Double($1.distance!)! }
        }
    }
    
    
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
    
    // controllershi gaditane
    func moveActiveIndicatorView(mainButton: UIButton, button2: UIButton, button3: UIButton, button4: UIButton, indicatorView: UIView) {
        mainButton.tintColor = CustomColors.specialOrangeColor
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

