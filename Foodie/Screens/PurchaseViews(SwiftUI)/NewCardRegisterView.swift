//
//  NewCardView.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 21.08.22.
//

import SwiftUI

struct NewCardRegisterView: View {
    //MARK: - Variables
    @State var name: String = ""
    @State var cardNumber: String = ""
    @State var expiryDate: String = ""
    @State var cvvString: String = ""
    var dismissAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Spacer()
            HStack {
                Text("Add New Card")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.init(CustomColors.specialOrangeColor!))
                    .padding(.vertical)
                Spacer()
                Button {
                    self.dismissAction()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.gray)
                }
                .padding()
            }
            
            CustomTextField(textFieldPlaceHolder: "name", text: $name, title: "Name On Card")
            
            CustomTextField(textFieldPlaceHolder: "card number", text: $cardNumber, title: "Card Number")
                .keyboardType(.numberPad)
                .onReceive(cardNumber.publisher.collect()) { self.cardNumber = String($0.prefix(19)).applyPattern() }
            
            HStack {
                CustomTextField(textFieldPlaceHolder: "MM/YY", text: $expiryDate, title: "Expiry Date")
                    .onReceive(expiryDate.publisher.collect()) { self.expiryDate = String($0.prefix(5)) }
                    .padding(.trailing)
            
                CustomTextField(textFieldPlaceHolder: "CVV", text: $cvvString, title: "Cvv")
                    .onReceive(cvvString.publisher.collect()) { self.cvvString = String($0.prefix(3)) }
                    .keyboardType(.numberPad)
                    .padding(.leading)
            }
            .padding(.vertical, 20)
            
            Button(action: {
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.5)) {
                    PurchaseViewModel.shared.addCreditCard(name: name, cardNumber: cardNumber, expiryDate: expiryDate, cvvString: cvvString, cardImage: "card\(Int.random(in: 1...3))")
                }
            }) {
                Text("Add Card")
                    .font(.system(size: 21, weight: .semibold))
                    .padding(.horizontal, 100)
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.init(CustomColors.specialOrangeColor!))
                    .clipShape(Rectangle())
                    .cornerRadius(15)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
                .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

struct CustomTextField: View {
    var textFieldPlaceHolder: String
    var text: Binding<String>
    var title: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color.init(uiColor: CustomColors.specialYellowColor!))
            TextField(textFieldPlaceHolder, text: text)
                Divider()
        }
        .padding(.vertical)
    }
}

struct NewCardView_Previews: PreviewProvider {
    static var previews: some View {
        NewCardRegisterView {
            print("pressed dismiss")
        }
    }
}
