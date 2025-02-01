
import SwiftUI

struct ProductDetailView: View {
    
    @ObservedObject var viewModel: ProductDetailViewModel
    
    // @State private var size = "Маленький"
    
    @State private var  count = 1
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack(spacing: 10){
            //Image(.details)
            
            VStack{
                
                ScrollView{
                    Image(uiImage: self.viewModel.image)
                        .resizable()
                        .scaledToFit()
                        //.frame(maxWidth: screen.width, maxHeight: 320)
                    
                }
                
                
                VStack(alignment: .leading, spacing: 30){
                    
                    
                    //VStack{
                        
                    VStack(alignment: .leading, spacing: 0.1){
                        Text(viewModel.product.title).foregroundStyle(Color.black)
                            .font(.title3.bold())
                            .padding()
                        
                        
                        Text("\(viewModel.product.descript)")
                            .lineLimit(nil).multilineTextAlignment(.leading).layoutPriority(1)
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .foregroundStyle(Color.black)
                        
                        //.padding()
                            .padding(.horizontal)
                        //.padding(.vertical, 4)
                        
                    }
                        HStack{
                            
                            Text("\(viewModel.getPrice(count: self.count)) din")
                                .font(.title2.bold()).foregroundStyle(Color.black).padding()
                            Spacer()
                            HStack {
                                Stepper("", value: $count, in: 1...10).accentColor(.black)
                                Text("\(self.count)").foregroundStyle(Color.black)
                                    .padding(.leading, 5)
                            }
                        
                            
                            .padding(.horizontal)
                           
                            
                        }
                   // }
                    
                    //.padding(.horizontal)
                    
                    HStack{
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            HStack(spacing: 5){
                                Image("BackButton")
                                Text("Back to\n catalog").lineLimit(nil).multilineTextAlignment(.leading).layoutPriority(1).foregroundStyle(Color.black).font(.system(size: 12))
                            }
                        }
                        //.padding()
                        
                      Spacer()
                        
                        Button {
                            print("add")
                            let position = Position(id: UUID().uuidString, product: viewModel.product, count: self.count)
                            //Вычисление ценника для добавленного в корзину
                            viewModel.product.price = viewModel.getPrice(count: self.count)
                            CartViewModel.shared.addPositions(position)
                            presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            HStack{
                                Image(.addCart)
                                Text("Add to\n cart").lineLimit(nil).multilineTextAlignment(.leading).layoutPriority(1).foregroundStyle(Color.black).font(.system(size: 12))
                            }
                        }
                    
                    }.padding(.horizontal)
                    
                   
                    
                    
                    
                }
            }
            .navigationBarBackButtonHidden()
            
            .frame(width: screen.width, height: screen.height * 0.65 )
            .background(Color.white)
            .padding(.top, 0)
            .ignoresSafeArea()
            
            
            About()
            
            
            Image(.spoon).padding(.bottom, 50)
            
            //Spacer()
         
        }
        .frame(width: screen.width, height: screen.height).ignoresSafeArea().background(.blueCustom)
        //
        .onAppear {
            self.viewModel.getImage()
        }
        
        //.frame(width: screen.width, height: screen.height).ignoresSafeArea()
        //.background(Color.blue)
        //.ignoresSafeArea()
        
    }
        
    
}

/*
struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(viewModel: ProductDetailViewModel(product: Product(id: "0", title: "pelmeni", imageUrl: "nil", price: 100, descript: "Самые лучшие среди пельменей")))
        
    }
}

*/

