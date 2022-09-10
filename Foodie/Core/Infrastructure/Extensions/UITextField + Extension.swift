//
//  UITextField - Extension.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 10.09.22.
//

import Foundation
import UIKit

extension UITextField {
    func modifyTextFields() {
        self.layer.cornerRadius = 28
        self.layer.masksToBounds = true
        self.setLeftPaddingPoints(20)
        self.backgroundColor = CustomColors.specialGrayColor!
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
