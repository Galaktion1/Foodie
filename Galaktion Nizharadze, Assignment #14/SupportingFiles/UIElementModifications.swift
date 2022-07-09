//
//  UIElementModifications.swift
//  Galaktion Nizharadze, Assignment #14
//
//  Created by Gaga Nizharadze on 09.07.22.
//

import Foundation
import UIKit

class UIElementModifications {
    
    func modifyButtons(button: UIButton, colorString: String) {
        button.backgroundColor = UIColor(named: colorString)!
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 31
    }
    
    func modifyTextFields(textField: UITextField) {
        textField.layer.cornerRadius = 31
        textField.layer.masksToBounds = true
        textField.setLeftPaddingPoints(20)
        textField.backgroundColor = UIColor(named: "specialGray")!
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

extension UIViewController {
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        self.present(alert, animated: true)
    }
}
