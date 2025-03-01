
import SwiftUI

struct ProfileView: View {
    
    enum Interaction: Hashable {
        case first, second, third
    }
    
    @FocusState private var focus: Interaction?
    
    @State private var isQuitAlertPresented = false
    @State private var isAuthViewPresented = false
    @State private var usersOrderShow = false
    @StateObject var viewModel: ProfileViewModel
    @StateObject var viewModelForOrders = AdminOrdersViewModel()
    @State private var isLoadingProfile = true // Флаг для проверки загрузки профиля

    var body: some View {
        
        VStack {
            if AuthService.shared.currentUser == nil {
                
                
                Button(action: {
                    isAuthViewPresented.toggle()
                }, label: {
                    Text("Join and order").fontWeight(.semibold).foregroundColor(.white).padding(15).background(Color("redFirma"))
                        
                        .cornerRadius(20)
                        
                })
                
                .fullScreenCover(isPresented: $isAuthViewPresented) {
                    AuthView()
                }
            } else {
                // Профиль загружен, отображаем основной контент
                if isLoadingProfile {
                    // Показать загрузку данных
                    ProgressView("Loading profile...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    Image(.profileText).padding(.top, 30)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image("NameImg").padding()
                            TextField("Name - MustHave", text: $viewModel.profile.name)
                                .focused($focus, equals: .first)
                                .font(.system(size: 16))
                                .foregroundStyle(.black)
                                .padding()
                                .background(.white)
                                .frame(height: 40)
                                .cornerRadius(25)
                            
                            Button {
                                isQuitAlertPresented.toggle()
                            } label: {
                                VStack {
                                    Image("ExitCirc")
                                    Text("Exit")
                                        .foregroundStyle(Color.white)
                                        .font(.system(size: 12))
                                }
                            }
                            .offset(y: 12)
                            .padding()
                            .confirmationDialog(Text("Do you really want to leave?"), isPresented: $isQuitAlertPresented) {
                                Button {
                                    AuthService.shared.signOut() // Выход из системы
                                    isAuthViewPresented.toggle() // Переход на страницу авторизации
                                } label: {
                                    Text("Yes")
                                }
                            }
                            .fullScreenCover(isPresented: $isAuthViewPresented, onDismiss: nil) {
                                AuthView()
                            }
                        }
                        .frame(height: 80)
                        
                        HStack {
                            Image("AdressImg").padding()
                            TextField("Address - MustHave!", text: $viewModel.profile.address)
                                .focused($focus, equals: .second)
                                .font(.system(size: 16))
                                .foregroundStyle(.black)
                                .padding()
                                .background(.white)
                                .frame(height: 40)
                                .cornerRadius(25)
                        }
                        .padding(.trailing, 12)
                        .frame(height: 80)
                        
                        HStack {
                            Image("PhoneImg").padding()
                            TextField("Phone - MustHave", value: $viewModel.profile.phone, format: .number)
                                .keyboardType(.asciiCapableNumberPad)
                                .focused($focus, equals: .third)
                                .font(.system(size: 16))
                                .foregroundStyle(.black)
                                .padding()
                                .background(.white)
                                .frame(height: 40)
                                .cornerRadius(25)
                            
                            Button {
                                print("save")
                                viewModel.setProfile()
                            } label: {
                                VStack {
                                    Image("NewSave")
                                    Text("Save")
                                        .foregroundStyle(Color.white)
                                        .font(.system(size: 12))
                                }
                            }
                            .padding()
                            .offset(y: 8)
                        }
                        .frame(height: 80)
                    }
                    
                    SistemInformation()
                    
                    List {
                        Image("yourOrders")
                        
                        if viewModel.orders.count == 0 {
                            Text("Your orders will be here")
                                .foregroundStyle(.black)
                                .font(.system(size: 16))
                        } else {
                            ForEach(viewModel.orders, id: \.id) { order in
                                OrderCell(order: order)
                                    .onTapGesture {
                                        viewModelForOrders.currentOrder = order
                                        usersOrderShow.toggle()
                                    }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .frame(maxHeight: 250)
                    .padding(.bottom, 40)
                    .preferredColorScheme(.light)
                }
            }
        }
        .frame(width: screen.width, height: screen.height)
        .ignoresSafeArea()
        .background(.blueCustom)
        .onSubmit {
            viewModel.setProfile()
            print("on submit")
        }
        .onAppear {
            if AuthService.shared.currentUser != nil {
                viewModel.getProfile()
                viewModel.getOrders()
                viewModelForOrders.getOrders()
                // Устанавливаем флаг, когда данные загружены
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isLoadingProfile = false
                }
            }
        }
        .onTapGesture {
            focus = nil
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel(profile: MVUser(id: "", name: "Ivan", phone: 35512556645, address: "anyWhere")))
    }
}
