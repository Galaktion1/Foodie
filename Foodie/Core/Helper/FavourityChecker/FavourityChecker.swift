//
//  FavourityChecker.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 20.09.22.
//

import Foundation

protocol FavourityCheckerProtocol {
    func favButton() -> Bool
    func checkIfFav(id: Int) -> Bool
    init(isFavourite: Bool, data: Restaurant)
}


class FavourityChecker: FavourityCheckerProtocol {
    
    var data: Restaurant
    var isFavourite: Bool
    
    required init(isFavourite: Bool, data: Restaurant) {
        self.isFavourite = isFavourite
        self.data = data
    }
    
    private let userDefaultsKeyForFavouriteRestaurantIds: String = "favRestaurantsIds"
    
    func favButton() -> Bool {
        var favouriteRestaurantIds = UserDefaults.standard.array(forKey: userDefaultsKeyForFavouriteRestaurantIds) as? [Int] ?? []
        
        isFavourite.toggle()
        
        if isFavourite {
            favouriteRestaurantIds.append(data.id)
            UserDefaults.standard.set(favouriteRestaurantIds, forKey: userDefaultsKeyForFavouriteRestaurantIds)
        } else {
            if let index = favouriteRestaurantIds.firstIndex(of: data.id) {
                favouriteRestaurantIds.remove(at: index)
                UserDefaults.standard.set(favouriteRestaurantIds, forKey: userDefaultsKeyForFavouriteRestaurantIds)
            }
        }
        
        return isFavourite
    }
    
    // MARK: - Funcs
    func checkIfFav(id: Int) -> Bool {
        let favouriteRestaurantIds = UserDefaults.standard.array(forKey: userDefaultsKeyForFavouriteRestaurantIds) as? [Int] ?? []
        
        isFavourite = favouriteRestaurantIds.contains(id)
        
        return isFavourite
    }

}
