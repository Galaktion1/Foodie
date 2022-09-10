//
//  MainViewCoordinator.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 05.09.22.
//

import Foundation
import UIKit

// MARK: - Coordinator pattern

// prot
class MainViewCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = MainViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    
    func moveToMenu(of restaurant: Restaurant) {
        
        let vc = RestaurantViewController.instantiate()
        vc.coordinator = self
        vc.data = restaurant
        vc.id = restaurant.id
        if let imgURLString = restaurant.restaurantImg {
            vc.mainImageURLString = imgURLString
        }
                    
        navigationController.pushViewController(vc, animated: true)
    }
}
