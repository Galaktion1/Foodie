//
//  CardModel.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 21.08.22.
//

import Foundation

struct Card: Identifiable, Codable, Equatable, Hashable {
    // MARK: - Properties
    var id = UUID().uuidString
    var cardHolder: String
    var cardNumber: String
    var cardValidity: String
    var cardImage: String?
    var amount: Double
    var cvv: Int?
    
    // MARK: - Init for cards display on swiftui view
    init(cardHolder: String, cardNumber: String, cardValidity: String, cardImage: String?, amount: Double) {
        self.cardHolder = cardHolder
        self.cardNumber = cardNumber
        self.cardValidity = cardValidity
        self.amount = amount
        self.cardImage = cardImage
    }
    
    // MARK: - Convenience init of card for firestore
    init(cardHolder: String, cardNumber: String, cardValidaity: String, amount: Double, cvv: Int, cardImage: String?) {
        self.cardHolder = cardHolder
        self.cardNumber = cardNumber
        self.cardValidity = cardValidaity
        self.amount = amount
        self.cvv = cvv
        self.cardImage = cardImage
        
    }
    
    var firestoreData: [String: Any] {   // firestore unfortunetly cant handle swift struct models.
        return [
            "id": id,
            "cardHolder": cardHolder,
            "cardNumber": cardNumber,
            "cardValidity": cardValidity,
            "cvv" : cvv ?? "",
            "amount": amount,
            "cardImage": cardImage ?? "card1"
        ]
    }
    
    var asDictionary : [String : Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label : String?, value : Any) -> (String, Any)? in
            guard let label = label else { return nil }
            return (label, value)
        }).compactMap { $0 })
        return dict
    }
}


