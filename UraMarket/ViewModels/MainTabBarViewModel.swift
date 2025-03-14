import Foundation

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class MainTabBarViewModel: ObservableObject{
    
    @Published var user: User?
    
    init(user: User? = nil){
        self.user = user
    }
}

