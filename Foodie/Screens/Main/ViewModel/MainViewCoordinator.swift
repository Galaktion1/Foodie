//
//  MainViewCoordinator.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 05.09.22.
//

import Foundation
import UIKit


protocol MainViewCoordinatorProtocol: Coordinator {
    func moveToMenu(of restaurant: Restaurant)
    func seeInfo(about food: Food)
    func logOut() -> UINavigationController
}

// MARK: - Coordinator pattern for MainView
class MainViewCoordinator: MainViewCoordinatorProtocol {
    
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
    
    func seeInfo(about food: Food) {
        let vc = DishDetailsVC()
        vc.data = food
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func logOut() -> UINavigationController {
        let sb = UIStoryboard(name: "SignIn&SignUp", bundle: Bundle.main)
        let nav = UINavigationController(rootViewController: sb.instantiateViewController(withIdentifier: "SignInViewController"))
        
        return nav
    }
}
