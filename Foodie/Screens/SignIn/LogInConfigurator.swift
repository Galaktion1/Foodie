//
//  LogInConfigurator.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 16.09.22.
//

import Foundation
import UIKit

enum LogInConfigurator {
    static func configure() -> UINavigationController {
        let firebaseManager = FirebaseManager()
        let worker = LogInWorker(apiManager: firebaseManager)
        let presenter = LogInPresenter()
        let interactor = LogInInteractor(presenter: presenter, worker: worker)
        let router = LogInRouter(dataStore: interactor)
        let sb = UIStoryboard(name: "SignIn&SignUp", bundle: Bundle.main)
        let viewController = sb.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        viewController.interactor = interactor
        viewController.router = router
        
        presenter.viewController = viewController
        router.viewController = viewController
        
        return UINavigationController(rootViewController: viewController)
    }
}
