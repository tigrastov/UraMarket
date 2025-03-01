
import Foundation

import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileViewModel: ObservableObject {
    
    @Published var profile: MVUser
    @Published var orders: [Order] = []
    
    init(profile: MVUser) {
        self.profile = profile
    }
    
    func getOrders() {
        // Проверка на nil для currentUser
        guard let currentUserID = AuthService.shared.currentUser?.uid else {
            print("Ошибка: текущий пользователь не найден")
            return
        }
        
        DatabaseService.shared.getOrders(by: currentUserID) { result in
            switch result {
            case .success(let orders):
                self.orders = orders
                print("Ветка пользователя в модели отработала")
                
                for (index, order) in self.orders.enumerated() {
                    DatabaseService.shared.getPositions(by: order.id) { result in
                        switch result {
                        case .success(let positions):
                            self.orders[index].positions = positions
                            print("Ветка пользователя в модели для получения позиции отработала")
                        case .failure(let error):
                            print("Ошибка получения позиций: \(error.localizedDescription)")
                        }
                    }
                }
                
                print("Всего заказов у пользователя: \(orders.count)")
                
            case .failure(let error):
                print("Ошибка получения заказов: \(error.localizedDescription)")
            }
        }
    }
    
    func setProfile() {
        DatabaseService.shared.setProfile(user: self.profile) { result in
            switch result {
            case .success(let user):
                print("Профиль успешно обновлен для пользователя: \(user.name)")
            case .failure(let error):
                print("Ошибка отправки данных: \(error.localizedDescription)")
            }
        }
    }
    
    func getProfile() {
        DatabaseService.shared.getProfile { result in
            switch result {
            case .success(let user):
                self.profile = user
            case .failure(let error):
                print("Ошибка получения профиля: \(error.localizedDescription)")
            }
        }
    }
}
