
import Foundation

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProductDetailViewModel: ObservableObject{
    //static let shared = ProductDetailViewModel()
    
    @Published var product: Product
    
    //@Published var sizes = ["Маленький - 1кг", "Средний - 1.5кг", "Большой - 2кг"]
    
    @Published var count = 0
    
    //@Published var image = UIImage(named: "View")!
    @Published var image = UIImage(named: "p1")!
    
    init (product: Product){
        self.product = product
    }
    
    
    /*
    func getPrice (size: String) -> Int{
        
        switch size {
            
        case "Маленький - 1кг": return product.price
            
        case "Средний - 1.5кг": return Int(Double(product.price) * 1.5)
            
        case "Большой - 2кг": return Int(Double(product.price) * 2)
            
        default: return 0
            
        }
    }
     */
    
    func getPrice(count: Int) -> Int {
        count * product.price
    }
    
    func getImage(){
        
        StorageService.shared.downLoadImageProduct(id: product.id) { result in
            switch result{
                
            case .success(let data):
                if let image = UIImage(data: data){
                    self.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}



