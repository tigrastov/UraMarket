
import Foundation

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AdminOrdersViewModel: ObservableObject{
  
    @Published var orders = [Order]()
    
    var currentOrder = Order(userID: "", date: Date(), status: "Новый" )
    
    
    func getOrders(){
        
        DatabaseService.shared.getOrders(by: nil) { result in
            switch result{
                 
            case .success(let orders):
                self.orders = orders
                
                for (index, order) in self.orders.enumerated(){
                    DatabaseService.shared.getPositions(by: order.id) { result in
                        switch result{
                            
                        case .success(let positions):
                            self.orders[index].positions = positions
                            print(self.orders[index].cost)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
                
                print("Всего заказов: \(orders.count)")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
}
 

