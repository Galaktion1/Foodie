//
//  CardView.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 20.09.22.
//

import SwiftUI

struct CardView: View {
    var card: Card
    var body: some View {
        Image(card.cardImage ?? "card1")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(40)
            .overlay(
                VStack(alignment: .leading, spacing: 10) {
                    Spacer()
                    Text(card.cardNumber)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(y: 25)
                    
                    Spacer()
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Card Holder")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Text(card.cardHolder)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        Spacer(minLength: 10)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Valid Till")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Text(card.cardValidity)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                    }
                    .foregroundColor(.white)
                }
                    .padding()
            )
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(cardHolder: "", cardNumber: "", cardValidaity: "", amount: 0, cvv: 0, cardImage: ""))
    }
}
