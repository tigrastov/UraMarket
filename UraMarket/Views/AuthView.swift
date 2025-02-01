
import SwiftUI

import Firebase
import FirebaseAuth

struct AuthView: View {
    
    enum Interaction: Hashable{
        case first, second, third
    }
    @FocusState private var focus: Interaction?
    @State private var isAuth = true
    @State private var isTabBarShow = false
    @State private var email = ""
    @State private var  password = ""
    @State private var confirmPassword = ""
    @State private var isShowAlert = false
    @State private var alertMassage = ""
    
    var body: some View {
        VStack{
            
            VStack {
                Image("Logotip").padding(.top, 60)
                    .padding(.leading, 20)
                
            }.padding(20).padding(.top, 30)
                .frame(width: screen.width, height: screen.height * 0.2)
            
            VStack {
                
                Text(isAuth ? "Login" : "Registration")
                    .padding(isAuth ? 16 : 24)
                    .padding(.horizontal, 30)
                    .font(.title2.bold())
                    .foregroundStyle(Color.black)
                Text(isAuth ? "To use the application you need to log in" : "To use the application, you must register and log in")
                    .padding()
                    .font(.title3)
                    .foregroundStyle(.white)
                /*
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 30))
                    .shadow(radius: 60)
                */
                
                TextField("email", text: $email)
                    .foregroundStyle(.black)
                    .focused($focus, equals: .first)
                    .padding()
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 25))
                    .padding(8)
                    .padding(.horizontal,12)
                
                SecureField("password", text: $password)
                    .foregroundStyle(.black)
                    .focused($focus, equals: .second)
                    .padding()
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 25))
                    .padding(8)
                    .padding(.horizontal, 12)
                
                if !isAuth {
                    SecureField("confirm password", text: $confirmPassword)
                        .foregroundStyle(.black)
                        .focused($focus, equals: .third)
                        .padding()
                        .background(Color.white)
                        .clipShape(.rect(cornerRadius: 25))
                        .padding(8)
                        .padding(.horizontal, 12)
                }
                
                Button {
                    if isAuth {
                        print("Авторизация")
                        
                        AuthService.shared.signIn(email: self.email, password: self.password) { result in
                            switch result {
                                
                            case .success(_):
                                isTabBarShow.toggle()
                            case .failure(let error):
                                isShowAlert.toggle()
                                alertMassage = "Authorisation Error \(error.localizedDescription)"
                            }
                        }
                        
                    } else{
                        print("Регистрация")
                        
                        guard password == confirmPassword else {
                            self.alertMassage = "Password mismatch"
                            self.isShowAlert.toggle()
                            return
                        }
                        
                        AuthService.shared.signUp(email: self.email, password: self.password) { result  in
                            switch result {
                                
                            case .success(let user):
                                alertMassage = "You have registered with email \(user.email!)"
                                self.isShowAlert.toggle()
                                self.email = ""
                                self.password = ""
                                self.confirmPassword = ""
                                self.isAuth.toggle()
                            case .failure(let error):
                                alertMassage = "Registration Error \(error.localizedDescription)"
                                self.isShowAlert.toggle()
                            }
                        }
                    }
                } label: {
                    Text(isAuth ? "Login" : "Create account")
                }
                .padding()
               .frame(maxWidth: screen.width)
               //.background(.bg)
               .background(LinearGradient(colors: [Color("blueCustom"), Color.white], startPoint: .leading, endPoint: .trailing))
                .clipShape(.rect(cornerRadius: 25))
                 .padding(8)
                .padding(.horizontal, 12)
                .font(.title3.bold())
                .foregroundStyle(Color.white)
                .shadow(radius: 10)
                
                Button {
                    isAuth.toggle()
                } label: {
                    Text(isAuth ? "Registration" : "Already have an account")
                }
                .padding(.horizontal)
                .frame(maxWidth: screen.width)
                
                .clipShape(.rect(cornerRadius: 12))
                .padding(8)
               .padding(.horizontal, 25)
                .font(.title3.bold())
                .foregroundStyle(Color.white)
                
                
                Image("Loc").padding()
            }
             .padding()
            .background(GlassView(removeEffects: false))
            .clipShape(.rect(cornerRadius: 15))
            .padding(isAuth ? 20 : 10)
            //.padding(.bottom, 50)
            .shadow(radius: 50)
            .alert(alertMassage, isPresented: $isShowAlert) {
                Button {} label: {
                    Text("OK")
                }
                
                
            }
            
        }
        
        
        .onTapGesture {
            focus = nil
        }
        
        .frame(width: screen.width, height: screen.height)
        
            .background(Image("AuthBg").resizable().scaledToFill().frame(width: screen.width, height: screen.height)
                .ignoresSafeArea())
        
            .animation(Animation.easeInOut(duration: 0.3), value: isAuth)
            .fullScreenCover(isPresented: $isTabBarShow) {
                
                
                if AuthService.shared.currentUser?.uid == "VzxhMgwnAcRNBBRlNalqYLtVVMf2"{
                    
                    AdminOrdersView()
                    
                }else {
                    let mainTabBarViewModel = MainTabBarViewModel(user: AuthService.shared.currentUser!)
                    
                    TabBar(viewModel: mainTabBarViewModel )
                }
                
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}



