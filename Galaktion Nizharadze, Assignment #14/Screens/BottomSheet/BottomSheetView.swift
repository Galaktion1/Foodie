//
//  BottomSheetView.swift
//  Galaktion Nizharadze, Assignment #14
//
//  Created by Gaga Nizharadze on 09.07.22.
//

import UIKit


protocol BottomSheetViewDelegate {
    func dismiss()
    func logOut()
}

class BottomSheetView: UIView {
    
    var delegate: BottomSheetViewDelegate?
    
    @IBAction func yesButton(_ sender: UIButton) {
        delegate?.logOut()
    }
    
    @IBAction func noButton(_ sender: UIButton) {
        delegate?.dismiss()
    }
}
