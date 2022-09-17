//
//  FirebaseManager.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 06.09.22.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseManager {
    
    private let db = Firestore.firestore()
    private let uid = Auth.auth().currentUser?.uid
    
    
    func signUp(with email: String, password: String, username: String, completion: @escaping (String) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                completion(error.localizedDescription)
            }
            else if let user = user {
                completion("Sign Up Success. \(user.user.uid)")
                
                self.db.collection("users").document(user.user.uid).setData(["creditCards" : [], "email" : email,"username" : username, "uid" : user.user.uid]) { error in
                    
                    if error != nil {
                        completion(error!.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    
    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                completion(.failure(error))
            }
            else if let user = user {
                completion(.success(user.user.uid))
            }
        }
    }
    
    func getUsername(completion: @escaping (String) -> Void) {
        
        db.collection("users").getDocuments() { (snapshot, error) in
            guard let currentUserDoc = snapshot?.documents.first(where: { ($0["uid"] as? String) == self.uid })  else { return }
            let username = currentUserDoc["username"] as! String
            completion(username)
        }
    }
    
    func addCreditCardInDataBase(nameOnCard: String, cardNumber: String, expiryDate: String, cvv: Int, cardImage: String ,completion: @escaping (Result<String, Error>) -> Void) {
        
        let card = Card(cardHolder: nameOnCard, cardNumber: cardNumber, cardValidaity: expiryDate, amount: 0.0, cvv: cvv, cardImage: cardImage)
        
        db.collection("users").getDocuments() { [self] (snapshot, error) in
            if let currentUserDoc = snapshot?.documents.first(where: { ($0["uid"] as? String) == uid }) {
                
                let userRef = db.collection("users").document(uid!)
                
                var cardsArray = currentUserDoc["creditCards"] as! Array<Any>
                
                cardsArray.append(card.firestoreData)
                
                userRef.updateData(["creditCards" : cardsArray]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success("added"))
                    }
                }
            }
        }
    }
    
    
    func getAllCards(completion: @escaping ([[String : Any]]) -> Void) {
        db.collection("users").getDocuments() { [self] (snapshot, error) in
            if let currentUserDoc = snapshot?.documents.first(where: { ($0["uid"] as? String) == uid }) {
               
                guard let cardsArray = currentUserDoc["creditCards"] as? [Any] else { return }
                let finallyCardsArray = cardsArray.map { $0 as! [String : Any] }
                completion(finallyCardsArray)
            }
        }
    }
    
    
    func updateAfterFoodOrder(with cardsArray: [Any]) {
        let userRef = db.collection("users").document(uid!)
        userRef.updateData(["creditCards" : cardsArray]) { error in
            if let error = error {
                print(error)
            } else {
                print("bought food succesfully.")
            }
        }
    }
    
    func logoutUser(completion: @escaping () -> ()) {
        
        do {
            try Auth.auth().signOut()
            completion()
        }
        catch { print("already logged out") }
        
    }
}
