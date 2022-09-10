//
//  UIViewController - Extension.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 10.09.22.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        self.present(alert, animated: true)
    }
}
