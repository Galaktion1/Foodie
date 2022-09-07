//
//  PurchaseViewModel.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 07.09.22.
//

import Foundation

class PurchaseViewModel {
    static let shared = PurchaseViewModel()
    
    let manager = FirebaseManager()
    
    func addCreditCard(name: String, cardNumber: String, expiryDate: String, cvvString: String, cardImage: String) {
        manager.addCreditCardInDataBase(nameOnCard: name, cardNumber: cardNumber, expiryDate: expiryDate, cvv: Int(cvvString) ?? 000, cardImage: cardImage) {  result in
            print(result)
        }
    }
    
    func fetchCards(completion: @escaping ([Card]) -> Void) {
        manager.getAllCards { cardsArray in
            let cards = cardsArray.map { try! JSONDecoder().decode(Card.self, from: JSONSerialization.data(withJSONObject: $0)) } //convertind dictionary to Card Model
            completion(cards)
        }
    }
    
    func orderFood(cards: inout [Card], selectedCardID: String, by amount: Double) {
        
        for index in 0 ..< cards.count {
            if cards[index].id == selectedCardID {
                cards[index].amount -= amount
            }
        }
        
        let cardsArrayForFirestore = cards.map { $0.asDictionary }
        manager.updateAfterFoodOrder(with: cardsArrayForFirestore)
    }
    
    
    
}
