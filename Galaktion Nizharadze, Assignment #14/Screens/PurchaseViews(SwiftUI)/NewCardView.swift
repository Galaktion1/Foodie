//
//  NewCardView.swift
//  Galaktion Nizharadze, Assignment #14
//
//  Created by Gaga Nizharadze on 21.08.22.
//

import SwiftUI

struct NewCardView: View {
    
    @State var name: String = ""
    @State var cardNumber: String = ""
    @State var expiryDate: String = ""
    @State var cvvString: String = ""
    var function: () -> Void
    
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
                    self.function()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.gray)
                }
                .padding()

                
//
            }
            
            
            CustomTextField(textFieldPlaceHolder: "name", text: $name, title: "Name On Card")
            
            CustomTextField(textFieldPlaceHolder: "card number", text: $cardNumber, title: "Card Number")
            
            HStack {
                
                CustomTextField(textFieldPlaceHolder: "MM/YY", text: $expiryDate, title: "Expiry Date")
                    .padding(.trailing)
            
                CustomTextField(textFieldPlaceHolder: "CVV", text: $cvvString, title: "Cvv")
                    .padding(.leading)
                
            }
            .padding(.vertical, 20)
            
            Button(action: {
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.5)) {
                    print(1)
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
        NewCardView {
            print("pressed dismiss")
        }
    }
}

