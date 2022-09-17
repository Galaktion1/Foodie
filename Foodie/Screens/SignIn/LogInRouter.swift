//
//  LogInRouter.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 16.09.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol LogInRoutingLogic {
    func navigateToMainScreen()
    func navigateToSignUpScreen()
}

protocol LogInDataPassing
{
  var dataStore: LogInDataStore { get }
}

class LogInRouter: NSObject, LogInRoutingLogic, LogInDataPassing
{
  weak var viewController: LogInViewController?
  var dataStore: LogInDataStore
    
    // MARK: - Object Lifecycle
    
    init(dataStore: LogInDataStore) {
        self.dataStore = dataStore
    }
    
    func navigateToMainScreen() {
        
        let nav = UINavigationController()
        let coordinator = MainViewCoordinator(navigationController: nav)
        viewController?.coordinator = coordinator
        viewController?.coordinator?.start()

        viewController?.view.window?.rootViewController = nav
        viewController?.view.window?.makeKeyAndVisible()
    }
    
    func navigateToSignUpScreen() {
        let vc = SignUpConfigurator.configure() as! SignUpViewController
        vc.delegate = viewController
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
  
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: LogInViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: LogInDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
