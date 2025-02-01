
import SwiftUI

struct CatalogView: View {
    
    let layout = [GridItem(.adaptive(minimum: screen.width / 1.5))]
    
    @StateObject var viewModel = CatalogViewModel()
    
    var body: some View {
        
        VStack {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    Section("") {
                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVGrid(columns: layout, spacing: 15) {
                                    ForEach(viewModel.Pelmeni, id: \.id){ item in
                                        
                                        NavigationLink {
                                            
                                            let viewModel = ProductDetailViewModel(product: item)
                                            
                                            ProductDetailView(viewModel: viewModel)
                                        }
                                        
                                    label: {
                                        ProductCell(product: item)
                                            .foregroundStyle(Color.black)
                                    }
                                
                                    }
                                }.padding()
                            }
                            
                        }
                }
                    .cornerRadius(15)
                    .shadow(radius: 50)
                    
                    
                }
            //.padding(.bottom, 40)
        }
        
        .background(Color.blueCustom).ignoresSafeArea()
        //.padding(.bottom, 40)
        //.navigationBarTitle("Menu")
        
            .onAppear {
            viewModel.getProducts()
            }
           
    }
}
struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView()
            
    }
}


