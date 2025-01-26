
import SwiftUI

struct TabBar: View{
    
    var viewModel: MainTabBarViewModel
    
    var body: some View {
        TabView{
            
           NavigationView{
                
                CatalogView()
           }
            .tabItem {
                //Image("ButtonCatalogLitle").resizable().scaledToFill()
                Image(systemName: "book.fill").tint(.white)//.foregroundStyle(.white).opacity(0.0)
                Text("Catalog")
            }
           // .foregroundStyle(.white)
            
            
            CartView(viewModel: CartViewModel.shared)
                .tabItem {
                    //Image("ButtonCartLitle").resizable().scaledToFill()
                    Image(systemName: "cart.circle.fill").tint(.white)//.foregroundStyle(.white)
                    Text("Cart")
                }
        
            ProfileView(viewModel: ProfileViewModel(profile: MVUser(id: "", name: "", phone: 0000000000, address: "")))
                .tabItem {
                    //Image("ButtonProfileLitle").resizable().scaledToFill()
                    Image(systemName: "person.circle.fill").tint(.white)//.foregroundStyle(.white)
                    Text("Profile")
                       // .foregroundStyle(.whiteCustom)
                }
        }
        
        //.colorInvert()
        .accentColor(.black)
         
        .onAppear{
            UITabBar.appearance().unselectedItemTintColor = UIColor.white
            
        }
        
    }
         
}




