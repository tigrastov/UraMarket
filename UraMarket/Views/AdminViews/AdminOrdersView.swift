
import SwiftUI

struct AdminOrdersView: View {
    
    @StateObject var viewModel = AdminOrdersViewModel()
    
    @State var  isOrderViewShow = false
    
    @State var isShowAuthView = false

    @State private var  isShowAddProductView = false
    
    var body: some View {
        
        VStack{
            
            HStack{
                Button {
                    
                    AuthService.shared.signOut()
                    isShowAuthView.toggle()
                     
                } label: {
                    Text("Exit").padding().foregroundStyle(Color.white).background(Color.red).cornerRadius(15).shadow(radius: 7)
                }
                
                Spacer()
                
                Button {
                    print("Adddddddddd")
                    isShowAddProductView.toggle()
                } label: {
                    Text("Add").padding().foregroundStyle(Color.white).background(Color.bg).cornerRadius(15).shadow(radius: 7)
                }

                
                Spacer()
                
                Button {
                    viewModel.getOrders()
                } label: {
                    Text("Update").padding().foregroundStyle(Color.white).background(Color.green).cornerRadius(15).shadow(radius: 7)
                }

                
            }.padding()
            
            
            List{
                ForEach(viewModel.orders, id: \.id) { order in
                    OrderCell(order: order)
                    
                        .onTapGesture {
                            
                            viewModel.currentOrder = order
                            
                            isOrderViewShow.toggle()
                        }
                }
            }.listStyle(.plain)
                .onAppear{
                    viewModel.getOrders()
                }
                .sheet(isPresented: $isOrderViewShow) {
                    let orderViewModel = OrderViewModel(order: viewModel.currentOrder)
                    OrderView(viewModel: orderViewModel)
        }
            
        }.fullScreenCover(isPresented: $isShowAuthView) {
            AuthView()
        }
        .sheet(isPresented: $isShowAddProductView) {
            AddProductView()
        }
    }
}

struct AdminOrdersView_Previews: PreviewProvider {
    static var previews: some View {
        AdminOrdersView()
            
    }
}



