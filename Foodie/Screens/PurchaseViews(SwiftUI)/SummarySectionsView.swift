//
//  SummarySectionsView.swift
//  Foodie
//
//  Created by Gaga Nizharadze on 20.09.22.
//

import SwiftUI

struct SummarySections: View {
    
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
                    Text("\(order.format()) ₾")
                    Text("\(delivery.format()) ₾")
                    Text("\(summary.format()) ₾")
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
