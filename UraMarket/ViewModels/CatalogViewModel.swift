import Foundation

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class CatalogViewModel: ObservableObject{
    static let shared = CatalogViewModel()
    
    @Published var Pelmeni = [
       Product(id: "0", title: "Пельмени из говядины", imageUrl: "nil", price: 1000, descript: "Пельмени ручной лепки с говядиной. Фасовка 1кг, 1.5кг, 2кг"),
       Product(id: "1", title: "Пельмени из говядины и свинины", imageUrl: "nil", price: 900, descript: "Пельмени ручной лепки с говядиной и свининой. Фасовка 1кг, 1.5кг, 2кг"),
       Product(id: "2", title: "Пельмени куриные", imageUrl: "nil", price: 800, descript: "Пельмени ручной лепки с курицей.  Фасовка 1кг, 1.5кг, 2кг")
    ]

    func getProducts(){
        DatabaseService.shared.getProduts { result in
            switch result{
                
            case .success(let products):
                self.Pelmeni = products
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

