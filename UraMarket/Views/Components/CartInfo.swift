//
//  CartInfo.swift
//  UraMarket
//
//  Created by Mac mini on 01.02.2025.
//

import SwiftUI

struct CartInfo: View {
    var body: some View {
        VStack{
            Text("Add items from the catalog to the cart. You can delete items individually by pressing the button. You can delete all items from the cart by clearing it with one button - Clear cart. If you have any questions, call +381 XXX XXX XXX").font(.system(size: 12)).foregroundStyle(.white).padding(.horizontal)
        }
    }
}

#Preview {
    CartInfo()
}
