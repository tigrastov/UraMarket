import SwiftUI

struct TabBar: View {
    
    var viewModel: MainTabBarViewModel
    
    var body: some View {
        TabView {
            NavigationStack {
                CatalogView()
            }
            .tabItem {
                Image(systemName: "book.fill")
                Text("Catalog")
            }
           
            CartView(viewModel: CartViewModel.shared)
                .tabItem {
                    Image(systemName: "cart.circle.fill")
                    Text("Cart")
                }
        
            ProfileView(viewModel: ProfileViewModel(profile: MVUser(id: "", name: "", phone: 0000000000, address: "")))
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.clear

           
            appearance.stackedLayoutAppearance.normal.iconColor = .white
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]

           
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "redFirma")
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "redFirma") ?? UIColor.black]

            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
