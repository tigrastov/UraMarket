import SwiftUI

struct CartView: View {
    
    @StateObject var viewModel: CartViewModel
    @State private var isShowAlertAboutOrderSent =  false
    @State private var isShowDialogOrder = false
    @State private var isShowAlertAboutEmptyOrder = false
    @State private var isAuthViewPresented = false
    
    var body: some View {
        
        ZStack {
            VStack {
                
                Image(.cartHead).padding(.top, 30)
                
                VStack {
                    
                    HStack(spacing: 180){
                        VStack{
                            Image("Wallet")
                            Text("Cost").foregroundStyle(.black).fontWeight(.semibold)
                        }
                        .offset(x: 20)
                       
                        Text("\(viewModel.cost) din").foregroundStyle(.black).fontWeight(.bold).padding()
                    }
                    
                    List(viewModel.positions){ position in
                        PositionCell(position: position)
                            .swipeActions(edge: .trailing,allowsFullSwipe: true) {
                                Button {
                                    viewModel.positions.removeAll { pos in
                                        pos.id == position.id
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                }.tint(Color("redFirma"))
                            }
                    }
                    .listStyle(.plain)
                    .preferredColorScheme(.light)
                    .navigationTitle("Cart")
                    
                }.background(Color.white).cornerRadius(20).shadow(radius: 5).padding(.horizontal).padding(.top, 10)
                .frame(height: screen.height / 2)
                
                HStack(spacing: 150){
                    Button {
                        viewModel.positions.removeAll()
                        print("Очистить корзину")
                    } label: {
                        //Image("ClearCartButton")
                        VStack{
                            Image(.garbage)
                            Text("Delete all").lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(Color.redFirma)
                                .font(.system(size: 13))
                                .fontWeight(.semibold)
                        }
                    }
                    
                    Button {
                        
                        if AuthService.shared.currentUser == nil {
                            // Показать экран авторизации
                            isAuthViewPresented.toggle()
                        } else {
                            isShowDialogOrder.toggle()
                        }
                    } label: {
                        VStack{
                            Image(.sent)
                            Text("Sent order").lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.white).font(.system(size: 13))
                                .fontWeight(.semibold)
                        }
                    }
                    .confirmationDialog("Do you want sent an order?", isPresented: $isShowDialogOrder) {
                        Button {
                            if viewModel.positions.count != 0{
                                print("sent an order")
                                isShowAlertAboutOrderSent.toggle()
                                
                                var order = Order(userID: AuthService.shared.currentUser!.uid,
                                                  date: Date(),
                                                  status: OrderStatus.new.rawValue)
                                order.positions = self.viewModel.positions
                                
                                DatabaseService.shared.setOrder(order: order) { result in
                                    switch result {
                                    case .success(let order):
                                        print(order.cost)
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                    }
                                }
                                viewModel.positions.removeAll()
                            } else {
                                isShowAlertAboutEmptyOrder.toggle()
                            }
                        } label: {
                            Text("Yes")
                        }
                    }
                    .alert(Text("Order is accepted!"), isPresented: $isShowAlertAboutOrderSent) {
                    } message: {
                        Text("To clarify the delivery details, our administrator will call you at the number specified in the profile settings")
                    }
                    .alert(Text("Error: empty order"), isPresented: $isShowAlertAboutEmptyOrder) {
                    } message: {
                        Text("The order cannot be empty")
                    }
                    
                }.padding(.vertical, 5)
                
                CartInfo()
                    .padding(.bottom, 50)
                
            }
            .frame(width: screen.width, height: screen.height).ignoresSafeArea()
            .background(.blueCustom).ignoresSafeArea()
            
            
            if AuthService.shared.currentUser == nil {
                VStack {
                    HStack {
                        Text("To place an order, you need to register. To do this, go to the Profile menu")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                        Spacer()
                    }
                    .background(Color("redFirma").opacity(0.7)) // Полупрозрачный фон
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.top, 3) // Отступ сверху
                }
                .frame(maxWidth: .infinity) // Растягиваем баннер по ширине экрана
                .transition(.move(edge: .top))
                .animation(.easeInOut, value: AuthService.shared.currentUser)
            }
        }
        .fullScreenCover(isPresented: $isAuthViewPresented) {
            AuthView() // Показываем экран авторизации
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(viewModel: CartViewModel.shared)
    }
}
