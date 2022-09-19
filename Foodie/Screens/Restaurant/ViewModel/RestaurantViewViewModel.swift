//
//  RestaurantViewViewModel.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 20.09.22.
//

import Foundation

class RestaurantViewViewModel {
    
    let favourityChecker: FavourityCheckerProtocol
    
    init(favourityChecker: FavourityCheckerProtocol) {
        self.favourityChecker = favourityChecker
    }
    
    func idetify(id: Int) -> Bool {
        favourityChecker.checkIfFav(id: id)
    }
    
    func makeFav() -> Bool {
        favourityChecker.favButton()
    }
}
