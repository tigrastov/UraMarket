import Foundation

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class CartViewModel: ObservableObject{
    
    static let shared = CartViewModel()
    private init(){}
    
  @Published var positions = [Position]()
    
    var cost: Int{
        var sum = 0
      
        for position in positions {
            sum += position.cost
        }
        return sum
    }
    
    func addPositions(_ position: Position) {
        self.positions.append(position)
    }
    
}

