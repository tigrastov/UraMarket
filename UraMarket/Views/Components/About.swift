//
//  About.swift
//  UraMarket
//
//  Created by Mac mini on 31.01.2025.
//

import SwiftUI

struct About: View {
    var body: some View {
        VStack{
            Text("A little about us. We are a food production company Baikal in Belgrade. We are engaged in the production of various semi-finished products and ready meals. We also deliver products around the city. More information on the website. For all questions of interest, do not hesitate - call +381 XXX XXX XXX").font(.system(size: 14)).foregroundStyle(Color.white).lineLimit(nil).multilineTextAlignment(.leading).padding(.horizontal)
        }
    }
}

#Preview {
    About()
}
