
import SwiftUI

struct OrderCell: View {
    
  var order: Order = Order(userID: "", date: Date(), status: "Новый ")
   // let order: Order
    var body: some View {
        VStack{
            HStack{
                Text("\(order.date)").lineLimit(nil).multilineTextAlignment(.leading).foregroundStyle(.black).font(.system(size: 10)).padding(.leading)
                Text("\(order.cost )").bold().frame(width: 90).font(.system(size: 14)).foregroundStyle(Color.red)
                Text("\(order.status )").frame(width: 100).font(.system(size: 14)).foregroundStyle(.black)
            }
            .background(.white).cornerRadius(15)
                //.padding()
                
        }
        .frame(height: 40)
    }
}
struct OrderCell_Previews: PreviewProvider {
    static var previews: some View {
       OrderCell()
   }
}


