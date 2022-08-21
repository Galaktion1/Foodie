//
//  CardModel.swift
//  Galaktion Nizharadze, Assignment #14
//
//  Created by Gaga Nizharadze on 21.08.22.
//

import Foundation

struct Card: Identifiable {
    var id = UUID().uuidString
    var cardHolder: String
    var cardNumber: String
    var cardVaidaity: String
    var cardImage: String
    var amount: Double
}


