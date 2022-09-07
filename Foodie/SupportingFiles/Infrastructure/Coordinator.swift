//
//  Coordinator.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 05.09.22.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

