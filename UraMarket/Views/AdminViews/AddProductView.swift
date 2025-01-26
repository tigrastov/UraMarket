
import SwiftUI

struct AddProductView: View {
    enum Interaction: Hashable{
        case first, second, third
    }
    @FocusState private var focus: Interaction?
    @State private var showImagePicker = false
    @State private var image = UIImage(named: "AddProd")!
    @State private var title: String = ""
    @State private var price: Int? = nil
    @State private var description: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            
            Text("Add").font(.title2).bold()
            
            
            Image(uiImage: image).resizable().frame(minWidth: 100,maxWidth: screen.width, minHeight: 100, maxHeight: screen.height).cornerRadius(12).shadow(radius: 7)
                .onTapGesture {
                showImagePicker.toggle()
            }
            
            TextField("Title", text: $title).focused($focus, equals: .first).foregroundStyle(Color.black).padding().background(Color("grey")).cornerRadius(15).shadow(radius: 7)
            
            TextField("Price", value: $price, format: .number).focused($focus, equals: .second).foregroundStyle(Color.black).padding().background(Color("grey")).cornerRadius(15).shadow(radius: 7)
            
            TextField("Description", text: $description).focused($focus, equals: .third).foregroundStyle(Color.black).padding().background(Color("grey")).cornerRadius(15).shadow(radius: 7)
            
            
            Button {
                print("Save")
                guard let price = price else {
                    print("Невозможно извлечь цену")
                    return
                }

                
                let product = Product(id: UUID().uuidString, title: title, price: price, descript: description)
                guard let imageData = image.jpegData(compressionQuality: 0.15) else{return}
                
                DatabaseService.shared.setProduct(product: product, image: imageData) { result in
                    switch result{
                        
                    case .success(let product):
                        print(product.title)
                        dismiss()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
                
                
            } label: {
                Text("Save").foregroundStyle(Color.white).padding().frame(width: 200, height: 75, alignment: .center).background(Color.green).cornerRadius(30).shadow(radius: 7)
            }
            
            Spacer()

            
            
        }.padding()
            
            .onTapGesture {
                focus = nil
            }
        
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
        }
    }
}

struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView()
            
    }
}




