import SwiftUI

struct CatalogView: View {
    
    let layout = [GridItem(.adaptive(minimum: screen.width / 1.5))]
    
    @StateObject var viewModel = CatalogViewModel()
    
    @State private var isAuthShow: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: layout, spacing: 15) {
                        ForEach(viewModel.Pelmeni, id: \.id) { item in
                            NavigationLink(destination: ProductDetailView(viewModel: ProductDetailViewModel(product: item))) {
                                ProductCell(product: item)
                                    .foregroundStyle(Color.black)
                            }
                        }
                    }
                    .padding()
                }
                .cornerRadius(15)
                .shadow(radius: 50)
            }
            .background(Color.blueCustom)
            .ignoresSafeArea()
            .onAppear {
                viewModel.getProducts()
            }
            
            .overlay {
                if AuthService.shared.currentUser == nil {
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                print("Button")
                                isAuthShow.toggle()
                            } label: {
                                Text("Login")
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                                    .padding(10)
                                    .background(Color("redFirma").opacity(0.6))
                                    .cornerRadius(20)
                            }
                            .padding(.top, 20) // Отступ от верхней части экрана
                            .padding(.trailing, 15) // Отступ справа
                        }
                        Spacer() 
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .fullScreenCover(isPresented: $isAuthShow) {
                        AuthView()
                    }
                }
            }
        }
    }
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView()
    }
}
