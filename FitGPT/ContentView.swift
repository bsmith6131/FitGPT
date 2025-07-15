import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedItem:
        PhotosPickerItem?
    
    @State private var selectedImage:
        UIImage?
    
    @State private var showingCamera = false //control camera sheet visiblity
    
    var body: some View {
        VStack {
         
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(25)
            }else {
                Text("NO IMAGE SELECTED")
                    .foregroundStyle(.indigo)
                    .font(.headline)
                    .padding()
            }
            
            Button(action: { showingCamera = true
            }){
                Text("TAKE PHOTO")
                    font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(25)
            }
            .sheet(isPresented: $showingCamera){
                CameraView(image: $selectedImage)
            }
            
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared() //bind to selected item
            ){
                Text("SELECT PHOTO")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .foregroundStyle(.white)
                    .cornerRadius(25)
            }
            .onChange(of: selectedItem){
                newItem in
                    //handle selected item
                if let newItem = newItem {
                    Task {
                        if let data =
                            try? await
                            newItem.loadTransferable(type: Data.self),
                           let image = UIImage (data: data) {
                            selectedImage = image //update the selected image
                        }
                    }
                }
            }
                    
        }
        .padding()
    }
}

#Preview {
    ContentView()
}


