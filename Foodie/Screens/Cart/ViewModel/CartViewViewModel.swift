//
//  CartViewViewModel.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 18.09.22.
//

import Foundation

class CartViewViewModel {
    
    func identifySections(section: Int, sectionCount: Int, completion: (String) -> ()) {
        if section == 0 {
            completion("Combos")
        } else if section == sectionCount {
            completion("Delivery details")
        }
    }
}
