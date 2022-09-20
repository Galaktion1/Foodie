//
//  SignUpRouter.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 20.09.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol SignUpRoutingLogic {
    func backToRootVC()
}

protocol SignUpDataPassing {
    var dataStore: SignUpDataStore { get }
}


class SignUpRouter: NSObject, SignUpRoutingLogic, SignUpDataPassing {
    weak var viewController: SignUpViewController?
    var dataStore: SignUpDataStore
    
    init(dataStore: SignUpDataStore) {
        self.dataStore = dataStore
    }
    
    func backToRootVC() {
        viewController?.navigationController?.popViewController(animated: true)
        viewController?.delegate?.presentCGMessage()
    }
}
