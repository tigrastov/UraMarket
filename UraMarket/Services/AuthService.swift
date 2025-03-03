import Foundation

import FirebaseAuth

 
class AuthService{
    static let shared = AuthService()
    private init(){}
    
    private let auth = Auth.auth()
    
     var currentUser: User?{
         return auth.currentUser
    }
    
    
    //Метод для разлогинивания
    
    func signOut(){
        
        do{
            try auth.signOut()
        } catch let error{
            print("Ошибка при разлогинивании: \(error.localizedDescription)")
        }
        
    }
    
    
    
    func signUp(email: String, password: String, completion: @escaping(Result<User, Error>) -> ())
    
    {
        
        auth.createUser(withEmail: email,
                        password: password) { result, error in
            
            if let result = result{
                
                let mvUser = MVUser(id: result.user.uid, name: "", phone: 0, address: "")
                
                DatabaseService.shared.setProfile(user: mvUser) { resultDB in
                    switch resultDB{
                        
                    case .success(_):
                        completion(.success(result.user))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
                
            }else if  let error = error{
                completion(.failure(error))
            }
            
        }
        
    }
    
    func signIn(email: String, password: String, completion: @escaping(Result<User, Error>) -> ()) {
         
        auth.signIn(withEmail: email, password: password) { result, error in
            
            if let result = result{
                completion(.success(result.user))
            }else if let error = error{
                completion(.failure(error))
            }
        }
    }
    
    
    
    func deleteUser(completion: @escaping(Result<Void, Error>) -> ()) {
        guard let user = auth.currentUser else {
            completion(.failure(NSError(domain: "AuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"])))
            return
        }

        // Сначала удаляем профиль из Firestore
        DatabaseService.shared.deleteProfile(userId: user.uid) { result in
            switch result {
            case .success():
                // После успешного удаления профиля из Firestore удаляем из Auth
                user.delete { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func reauthenticate(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = auth.currentUser else {
            completion(.failure(NSError(domain: "No user", code: 0)))
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        user.reauthenticate(with: credential) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
}


