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
        let viewController = MainViewController.instantiate()
        viewController.coordinator = self
        let worker = MainWorker()
        let presenter = MainPresenter()
        let interactor = MainInteractor(presenter: presenter, worker: worker)
        let router = MainRouter(dataStore: interactor)
        viewController.interactor = interactor
        viewController.router = router

        presenter.viewController = viewController
        router.viewController = viewController
        navigationController.pushViewController(viewController, animated: false)
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
        let nav = UINavigationController(rootViewController: sb.instantiateViewController(withIdentifier: "LogInViewController"))
        
        return nav
    }
}
