import SwiftUI
import Firebase
import FirebaseAuth

struct AuthView: View {
    
    enum Interaction: Hashable {
        case first, second, third
    }
    
    @FocusState private var focus: Interaction?
    @State private var isAuth = true
    @State private var isTabBarShow = false
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isShowAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            
            VStack {
                Image("Logotip")
                    .padding(.top, 60)
                    .padding(.leading, 20)
            }
            .padding(20)
            .padding(.top, 30)
            .frame(width: screen.width, height: screen.height * 0.2)
            
            VStack {
                
                Text(isAuth ? "Login" : "Registration")
                    .padding(isAuth ? 16 : 24)
                    .padding(.horizontal, 30)
                    .font(.title2.bold())
                    .foregroundStyle(Color.black)
                
                Text(isAuth ? "To use the application you need to log in" : "To use the application, you must register and log in")
                    .lineLimit(nil)
                    .foregroundStyle(.white)
                    .font(.system(size: 15))
                    .padding()
                
                TextField("Email", text: $email)
                    .foregroundStyle(.black)
                    .focused($focus, equals: .first)
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding(8)
                    .padding(.horizontal, 12)
                
                SecureField("Password", text: $password)
                    .foregroundStyle(.black)
                    .focused($focus, equals: .second)
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding(8)
                    .padding(.horizontal, 12)
                
                if !isAuth {
                    SecureField("Confirm Password", text: $confirmPassword)
                        .foregroundStyle(.black)
                        .focused($focus, equals: .third)
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding(8)
                        .padding(.horizontal, 12)
                }
                
                Button {
                    if isAuth {
                        print("Login")
                        
                        AuthService.shared.signIn(email: self.email, password: self.password) { result in
                            switch result {
                            case .success(_):
                                isTabBarShow.toggle()
                            case .failure(let error):
                                isShowAlert.toggle()
                                alertMessage = "Authorization Error \(error.localizedDescription)"
                            }
                        }
                    } else {
                        print("Registration")
                        
                        guard password == confirmPassword else {
                            alertMessage = "Password mismatch"
                            isShowAlert.toggle()
                            return
                        }
                        
                        AuthService.shared.signUp(email: self.email, password: self.password) { result in
                            switch result {
                            case .success(let user):
                                alertMessage = "You have registered with email \(user.email!)"
                                isShowAlert.toggle()
                                email = ""
                                password = ""
                                confirmPassword = ""
                                isAuth.toggle()
                            case .failure(let error):
                                alertMessage = "Registration Error \(error.localizedDescription)"
                                isShowAlert.toggle()
                            }
                        }
                    }
                } label: {
                    Text(isAuth ? "Login" : "Create Account")
                }
                .padding()
                .frame(maxWidth: screen.width)
                .background(LinearGradient(colors: [Color("blueCustom"), Color.white], startPoint: .leading, endPoint: .trailing))
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(8)
                .padding(.horizontal, 12)
                .font(.title3.bold())
                .foregroundStyle(Color.white)
                .shadow(radius: 10)
                
                Button {
                    isAuth.toggle()
                } label: {
                    Text(isAuth ? "Register" : "Already have an account")
                }
                .padding(.horizontal)
                .frame(maxWidth: screen.width)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(8)
                .padding(.horizontal, 25)
                .font(.title3.bold())
                .foregroundStyle(Color.white)
                
                Button {
                    isTabBarShow.toggle()
                } label: {
                    Text("I'll register later").foregroundStyle(Color("redFirma")).fontWeight(.bold)
                }
                
                Image("Loc").padding()
            }
            .padding()
            .background(GlassView(removeEffects: false))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(isAuth ? 20 : 10)
            .shadow(radius: 50)
            .alert(alertMessage, isPresented: $isShowAlert) {
                Button {} label: {
                    Text("OK")
                }
            }
            
        }
        .preferredColorScheme(.light)
        .onTapGesture {
            focus = nil
        }
        .frame(width: screen.width, height: screen.height)
        .background(
            Image("AuthBg")
                .resizable()
                .scaledToFill()
                .frame(width: screen.width, height: screen.height)
                .ignoresSafeArea()
        )
        .animation(Animation.easeInOut(duration: 0.3), value: isAuth)
        
        .fullScreenCover(isPresented: $isTabBarShow) {
            // Здесь проверяем, что текущий пользователь не nil
            if let currentUser = AuthService.shared.currentUser {
                if currentUser.uid == "VzxhMgwnAcRNBBRlNalqYLtVVMf2" {
                    AdminOrdersView()
                } else {
                    let mainTabBarViewModel = MainTabBarViewModel(user: currentUser)
                    TabBar(viewModel: mainTabBarViewModel)
                }
            } else {
                // Если пользователь не авторизован, показываем экран авторизации или другую логику
                    
                    let mainTabBarViewModel = MainTabBarViewModel(user: nil)
                    TabBar(viewModel: mainTabBarViewModel)
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
