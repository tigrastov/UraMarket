
import Foundation
import SwiftUI


struct ImagePicker: UIViewControllerRepresentable{
     
    @Environment(\.presentationMode) private var presentationMode
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var selectedImage: UIImage
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
         return imagePicker
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject,  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        
        var parent: ImagePicker
        
        init (_ parent: ImagePicker){
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[ UIImagePickerController.InfoKey.originalImage] as? UIImage   {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
    
}


