//
//  PurchaseView.swift
//  Galaktion Nizharadze, Assignment #14
//
//  Created by Gaga Nizharadze on 21.08.22.
//

import SwiftUI

struct PurchaseView: View {
  
    @State var startAnimation = false
    @State var startCardRotation = false
    @State var cardAnimation = false
    @State var address = "Tbilisi, Chavchavadzis 12"
    @State var addCardAction = false
    
    @State var dismissNewCardView = false
    
    @State var isOnByCash = false
    
    @State var selectedCard: Card = Card(cardHolder: "", cardNumber: "", cardVaidaity: "", cardImage: "", amount: 0.0)
    
    var foodPrice: Double
    var deliveryPrice: Double
    var summaryPrice: Double
    
    let specialOrange = Color.init(UIColor(named: "specialOrange")!)
    
   
    func dismissNewCard() {
        addCardAction = false
    }
    
    @Namespace var animation
    
    @Environment(\.colorScheme) var colorScheme
    
    
    var cards = [
        Card(cardHolder: "Galaktion Nizharadze", cardNumber: "1234 5678 9101 1121", cardVaidaity: "12/23", cardImage: "card1", amount: 120.4),
        Card(cardHolder: "Giorgi Tkeshelashvili", cardNumber: "3425 0283 0182 9184", cardVaidaity: "04/24", cardImage: "card2", amount: 833.8),
        Card(cardHolder: "Mirian Barateoni", cardNumber: "2415 4242 5820 9384", cardVaidaity: "09/26", cardImage: "card3", amount: 382.4)
    ]
    
    var body: some View {
        
        let paymentOnDeliveryCheckBox = Toggle("", isOn: $isOnByCash)
            .toggleStyle(CheckboxToggleStyle())
            .font(.system(size: 23))
            .foregroundColor(specialOrange)
        
        ScrollView {
            
            VStack {
                
                ZStack {
                    ForEach(cards.indices.reversed(), id: \.self) { index in
                        CardView(card: cards[index])
                            .scaleEffect(selectedCard.id == cards[index].id ? 1 : index == 0 ? 1 : 0.9)
                        
                            .rotationEffect(.init(degrees: startAnimation ? 0 :  index == 1 ? -15 : (index == 2 ? 15 : 0)))
                        
                        
                        
                            .onTapGesture {
                                animateView(card: cards[index])
                            }
                            .offset(y: startAnimation ? 0 : index == 1 ? 60 : (index == 2 ? -60 : 0))
                        
                            .matchedGeometryEffect(id: "CARD_ANIMATION", in: animation)
                        
                        
                            .rotationEffect(.init(degrees: selectedCard.id == cards[index].id && startCardRotation ? -90 : 0))
                        
                        
                        // moving selected card to top
                        
                            .zIndex(selectedCard.id == cards[index].id ? 1000 : 0)
                        
                            .opacity(startAnimation ? selectedCard.id == cards[index].id ? 1 : 0 : 1)
                    }
                }
                .rotationEffect(.init(degrees: 90))
                .frame(height: getRect().width - 30)
                .scaleEffect(0.9)
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Total Amount")
                            .font(.callout)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Button(action: {
                                addCardAction = true
//                                dismissNewCardView = true
                            
                            
                        }, label: {
                            Text("+ add new card")
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .padding(.vertical)
                        })
//                        .sheet(isPresented: $dismissNewCardView) {
//                                    NewCardView()
//                                }
                    }
                    
                    
                    Text("₾ \(getTotalAmount().format(f: ".1"))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Payment On Delivery")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(specialOrange)
                        Spacer()
                        
                        paymentOnDeliveryCheckBox
                        
                    }
                    
                    
                    Text("\(address)")
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Spacer()
                    
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                Spacer()
                    
                summarySections(order: foodPrice, delivery: deliveryPrice, summary: summaryPrice)
            }
            
            

            PurchaseButton()
            
            
        }
        .frame( maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primary.opacity(0.04).ignoresSafeArea())
        .blur(radius: cardAnimation ? 100 : 0)
        .blur(radius: addCardAction ? 100 : 0)
        .overlay(
            ZStack {
                if addCardAction {
                    NewCardView(function: self.dismissNewCard)
                }
            }
        )
        .overlay(
            
            VStack {
                ZStack(alignment: .topTrailing, content: {
                    if cardAnimation {
                        Button(action: {
                            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.5)) {
                                startCardRotation = false
                                
                                selectedCard = Card(cardHolder: "", cardNumber: "", cardVaidaity: "", cardImage: "", amount: 0.0)
                                startAnimation = false
                                cardAnimation = false
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(colorScheme != .dark ? .white : .black)
                                .padding()
                                .background(Color.primary)
                                .clipShape(Circle())
                        }
                        .padding()
                        
                        
                        CardView(card: selectedCard)
                            .matchedGeometryEffect(id: "CARD_ANIMATION", in: animation)
                            .padding(.top, -(getRect().height / 20))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        
                    }
                })
                
                
                
                if cardAnimation {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Card Amount")
                            .font(.callout)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                        
                        Text("\(selectedCard.amount.format(f: ".1")) ₾")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    summarySections(order: foodPrice, delivery: deliveryPrice, summary: summaryPrice)
                    
                    PurchaseButton()
                        
                }
            }
            
            
        )
    }
    
    private func animateView(card: Card) {
        
        selectedCard = card
        
        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)) {
            startAnimation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring()) {
                startCardRotation = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring()) {
                cardAnimation = true
            }
        }
    }
    
    private func getTotalAmount() -> Double {
        cards.reduce(0.0) { partialResult, card in
            partialResult + card.amount
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PurchaseView(foodPrice: 0, deliveryPrice: 0, summaryPrice: 0)
        }
        
    }
}

extension View {
    func getRect() -> CGRect {
        UIScreen.main.bounds
    }
}


struct CardView: View {
    var card: Card
    var body: some View {
        Image(card.cardImage)
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
                            
                            Text(card.cardVaidaity)
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



struct PurchaseButton:  View {
    var body: some View {
        Button(action: {
            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.5)) {
                print(1)
            }
        }) {
            Text("Purchase")
                .font(.system(size: 23, weight: .semibold))
                .padding(.horizontal, 50)
                .foregroundColor(.white)
                .padding()
                .background(Color.init(UIColor(named: "specialOrange")!))
                .clipShape(Rectangle())
                .cornerRadius(15)
        }
        .padding()
        
    }
}



struct CheckboxToggleStyle: ToggleStyle {
    
    @Environment(\.isEnabled) var isEnabled
    
    @State var isActive = false
    
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
            if configuration.isOn {
            }// toggle the state binding
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "checkmark.circle")
                    .imageScale(.large)
            }
        })
        .buttonStyle(PlainButtonStyle()) // remove any implicit styling from the button
        .disabled(!isEnabled)
    }
    
}


struct summarySections: View {
    
    var order: Double
    var delivery: Double
    var summary: Double
   
    
    var body: some View {
        HStack {
            VStack {
                Group {
                    Text("Order")
                    Text("Delivery")
                    Text("Summary")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 0.1)
                .padding(.leading)
            }
            
            
            VStack {
                Group {
                    Text("\(order.format(f: ".1")) ₾")
                    Text("\(delivery.format(f: ".1")) ₾")
                    Text("\(summary.format(f: ".1")) ₾")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 0.1)
                .padding(.trailing)
                
            }
            
        }
    }
}
