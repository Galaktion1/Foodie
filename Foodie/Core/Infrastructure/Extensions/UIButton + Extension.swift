//
//  UIButton - Extension.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 10.09.22.
//

import Foundation
import UIKit

extension UIButton {
    func modifyButtons(color: UIColor) {
        self.backgroundColor = color
        self.titleLabel?.textColor = .white
        self.layer.cornerRadius = 27.5
    }
}
