
import SwiftUI
import FirebaseCore
import FirebaseAuth
let screen = UIScreen.main.bounds

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      print("Firebase configured")

    return true
  }
}

@main
struct UraMarketApp: App {
    @State private var isLoading: Bool = true
    @State private var user: FirebaseAuth.User? = nil  // Сначала nil

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        // Firebase настраивается через AppDelegate, повторно не вызываем configure()
    }

    var body: some Scene {
        WindowGroup {
            if isLoading {
                LaunchView(isLoading: $isLoading)
            } else {
                NavigationView {
                    if let user = user {
                        if user.uid == "VzxhMgwnAcRNBBRlNalqYLtVVMf2" {
                            AdminOrdersView()
                        } else {
                            let viewModel = MainTabBarViewModel(user: user)
                            TabBar(viewModel: viewModel)
                        }
                    } else {
                        // Если пользователь не авторизован, даем доступ к каталогу
                        let viewModel = MainTabBarViewModel(user: nil)
                        TabBar(viewModel: viewModel)
                    }
                }
                .onAppear {
                    loadUser() // Загружаем пользователя только после запуска Firebase
                }
            }
        }
    }

    private func loadUser() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            user = AuthService.shared.currentUser // Загружаем юзера позже
        }
    }
}
