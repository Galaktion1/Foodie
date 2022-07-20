//
//  MainViewViewModel.swift
//  Galaktion Nizharadze, Assignment #14
//
//  Created by Gaga Nizharadze on 20.07.22.
//

import Foundation
import UIKit

class MainViewViewModel {
    
    func moveActiveIndicatorView(mainButton: UIButton, button2: UIButton, button3: UIButton, button4: UIButton, indicatorView: UIView) {
        mainButton.tintColor = UIColor(named: "specialOrange")
        button2.tintColor = .systemGray
        button3.tintColor = .systemGray
        button4.tintColor = .systemGray
        
        let xCoordinant = mainButton.frame.origin.x
        let mainButtonWidth = mainButton.frame.width
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options:[], animations: {
            indicatorView.transform = CGAffineTransform(translationX: xCoordinant, y: 0)
            indicatorView.frame.size.width = mainButtonWidth
            }, completion: nil)
    }

}
