//
//  UIStoryboard - Extension.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 10.09.22.
//

import Foundation
import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: String(id.prefix(id.count - 14)), bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
