import SwiftUI

struct OrderView: View {
   
   @StateObject var viewModel: OrderViewModel
   
   var statuses: [String]{
       var sts = [String]()
       for status in OrderStatus.allCases{
           sts.append(status.rawValue )
       }
       return sts
   }
   
   var body: some View {
       VStack(alignment: .leading, spacing: 10) {
           
           
           Text("\(viewModel.order.date)")
           Text("\(viewModel.user.name)").font(.title3)
           Text("\(viewModel.user.phone)").bold()
           Text("\(viewModel.user.address)")
          
           
       }.padding()
           .onAppear {
               viewModel.getUserData()
           }
       
       if let user = AuthService.shared.currentUser{
           
           if user.uid == "VzxhMgwnAcRNBBRlNalqYLtVVMf2"{
               
               Picker(selection: $viewModel.order.status) {
                   ForEach(statuses, id: \.self) {status in
                       Text(status)
                   }
               } label: {
                   Text("Order status")
                   
               }.pickerStyle(.segmented)
               .onChange(of: viewModel.order.status) { newStatus in
                print(newStatus)
                   DatabaseService.shared.setOrder(order: viewModel.order) { result in
                       switch result{
                           
                       case .success(let order):
                           print(order.status)
                       case .failure(let error):
                           print(error.localizedDescription)
                       }
                   }
               }
           }
               
           }
       
           
           List{
               ForEach(viewModel.order.positions, id: \.id) {position in
                   PositionCell(position: position)
               }
               
               Text("amount \(viewModel.order.cost) ").bold().foregroundStyle(Color.red)
           }
       
       if let  user = AuthService.shared.currentUser{
           if user.uid != "VzxhMgwnAcRNBBRlNalqYLtVVMf2"{
               Text("To clarify the delivery details, our administrator will call you at the number specified in the profile settings").foregroundStyle(Color("darkRed")).padding()
           }
       }
      
   }
}

struct OrderView_Previews: PreviewProvider {
   static var previews: some View {
       OrderView(viewModel: OrderViewModel(order: Order(userID: "", date: Date(), status: "Новый")))
           
   }
}



