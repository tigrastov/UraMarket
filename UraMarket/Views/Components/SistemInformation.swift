//
//  SistemInformation.swift
//  UraMarket
//
//  Created by Mac mini on 31.01.2025.
//

import SwiftUI

struct SistemInformation: View {
    var body: some View {
        VStack{
            Text("Dear customer! We have the following system. You place an order, and we call you on the day of the order at the specified phone number to clarify the delivery details. Therefore, before placing an order, make sure that your phone number is correct, active and available for communication").lineLimit(nil).multilineTextAlignment(.leading).foregroundStyle(.white).font(.system(size: 14)).padding(.horizontal)
        }
    }
}

#Preview {
    SistemInformation()
}
