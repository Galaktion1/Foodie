//
//  PurchaseView.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 21.08.22.
//

import SwiftUI

struct PurchaseView: View {
    // MARK: - Variables
    @State var startAnimation = false
    @State var startCardRotation = false
    @State var cardAnimation = false
    @State var address = "Tbilisi, Chavchavadzis 12"
    @State var addCardAction = false
    @State var dismissNewCardView = false
    @State var isOnByCash = false
    @State var selectedCard: Card = Card(cardHolder: "", cardNumber: "", cardValidity: "", cardImage: "", amount: 0.0)
    
    weak var vc: UINavigationController!
    var foodPrice: Double
    var deliveryPrice: Double
    var summaryPrice: Double
    var foods: [ChosenFood]
    let specialOrange = Color.init(CustomColors.specialOrangeColor!)
    
    @State var cards = [Card]()
    private let viewModel = PurchaseViewModel()
    
    @Namespace var animation
    @Environment(\.colorScheme) var colorScheme
    
    private func getCards() {
        viewModel.fetchCards { cardsArray in
            cards = cardsArray
        }
    }
    
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
                .onAppear { getCards() }
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Total Amount")
                            .font(.callout)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                        Spacer()
                        Button(action: {
                            addCardAction = true
                            
                        }, label: {
                            Text("+ add new card")
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .padding(.vertical)
                        })
                    }
                    
                    Text("₾ \(getTotalAmount().format())")
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
                
                SummarySections(order: foodPrice, delivery: deliveryPrice, summary: summaryPrice)
            }
            
            PurchaseButton(vc: vc, orderPrice: foodPrice, deliveryPrice: deliveryPrice, summaryPrice: summaryPrice, selectedCardAmount: nil, foods: foods)
            
        }
        .frame( maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primary.opacity(0.04).ignoresSafeArea())
        .blur(radius: cardAnimation ? 100 : 0)
        .blur(radius: addCardAction ? 100 : 0)
        .overlay(
            ZStack {
                if addCardAction {
                    NewCardRegisterView(dismissAction: self.dismissNewCard)
                        .navigationBarHidden(true)
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
                                
                                selectedCard = Card(cardHolder: "", cardNumber: "", cardValidity: "", cardImage: "", amount: 0.0)
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
                        
                        Text("\(selectedCard.amount.format()) ₾")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    SummarySections(order: foodPrice, delivery: deliveryPrice, summary: summaryPrice)
                    
                    PurchaseButton(vc: vc, orderPrice: foodPrice, deliveryPrice: deliveryPrice, summaryPrice: summaryPrice, selectedCardAmount: selectedCard.amount, foods: foods, cards: cards, selectedCardID: selectedCard.id)
                }
            })
    }
    
    // MARK: - Funcs
    private func dismissNewCard() {
        addCardAction = false
        getCards()
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
            PurchaseView(vc: nil, foodPrice: 0, deliveryPrice: 0, summaryPrice: 0, foods: [])
        }
    }
}


struct PurchaseButtonLabel: View {
    var body: some View {
        Text("Purchase")
            .font(.system(size: 23, weight: .semibold))
            .padding(.horizontal, 50)
            .foregroundColor(.white)
            .padding()
            .background(Color.init(CustomColors.specialOrangeColor!))
            .clipShape(Rectangle())
            .cornerRadius(15)
    }
}

struct PurchaseButton:  View {
    
    var vc: UINavigationController
    var orderPrice: Double
    var deliveryPrice: Double
    var summaryPrice: Double?
    var selectedCardAmount: Double?
    var foods: [ChosenFood]
    
    var cards: [Card]?
    var selectedCardID: String?
    
    let viewModel = PurchaseViewModel()
    
    @State private var moveToCompletedPurchaseVC = false
    var body: some View {
        
        Button {
            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.5)) {
                
                if let selectedCardAmount = selectedCardAmount, let summaryPrice = summaryPrice, var cards = cards, let selectedCardID = selectedCardID {
                    if summaryPrice < selectedCardAmount {
                        viewModel.orderFood(cards: &cards, selectedCardID: selectedCardID, by: summaryPrice)
                        moveToCompletedPurchaseVC = true
                    }
                }
                
                if selectedCardID == nil {
                    moveToCompletedPurchaseVC = true
                }
            }
        } label: {
            PurchaseButtonLabel()
        }
        .fullScreenCover(isPresented: $moveToCompletedPurchaseVC, content: {
            CompletedOrderViewControllerRepresentation(navigationControllerr: vc, orderPrice: orderPrice, deliveryPrice: deliveryPrice, summaryPrice: summaryPrice ?? 0.0 )
        })
    }
    
}

struct CompletedOrderViewControllerRepresentation: UIViewControllerRepresentable {
    
    var navigationControllerr: UINavigationController
    var orderPrice: Double
    var deliveryPrice: Double
    var summaryPrice: Double
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CompletedOrderViewControllerRepresentation>) -> UINavigationController {
        let controller = CompletedOrderViewController()
        
        controller.orderPrice = "\(orderPrice.format()) ₾"
        controller.deliveryPrice  = "\(deliveryPrice.format()) ₾"
        controller.summaryPrice  = "\(summaryPrice.format()) ₾"
        
        navigationControllerr.viewControllers = []
        let navController = UINavigationController(rootViewController: controller)
        
        return navController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: UIViewControllerRepresentableContext<CompletedOrderViewControllerRepresentation>) {
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
