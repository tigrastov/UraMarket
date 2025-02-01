
import SwiftUI

struct TabBar: View{
    
    var viewModel: MainTabBarViewModel
    
    var body: some View {
        TabView{
            
           NavigationView{
                
                CatalogView()
           }
            .tabItem {
                
                Image(systemName: "book.fill").tint(.white)
                Text("Catalog")
            }
           
            
            
            CartView(viewModel: CartViewModel.shared)
                .tabItem {
                    
                    Image(systemName: "cart.circle.fill").tint(.white)
                    Text("Cart")
                }
        
            ProfileView(viewModel: ProfileViewModel(profile: MVUser(id: "", name: "", phone: 0000000000, address: "")))
                .tabItem {
                    Image(systemName: "person.circle.fill").tint(.white)
                    Text("Profile")
                       
                }
        }
        
        //.colorInvert()
        .accentColor(.black)
         
        .onAppear{
            UITabBar.appearance().unselectedItemTintColor = UIColor.white
            
        }
        
    }
         
}




