import SwiftUI
import PhotosUI
import UIKit

struct ContentView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showingCamera = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Image Display Area
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(25)
                    .shadow(radius: 5)
            } else {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 300)
                    .overlay(
                        VStack {
                            Image(systemName: "photo")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("NO IMAGE SELECTED")
                                .foregroundStyle(.indigo)
                                .font(.headline)
                        }
                    )
            }
            
            // Photo Library Button
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Label("Select Photo", systemImage: "photo.on.rectangle")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .foregroundStyle(.white)
                    .cornerRadius(25)
            }
            .onChange(of: selectedItem) { newItem in
                if let newItem = newItem {
                    Task {
                        do {
                            if let data = try await newItem.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                selectedImage = image
                            }
                        } catch {
                            alertMessage = "Failed to load image: \(error.localizedDescription)"
                            showingAlert = true
                        }
                    }
                }
            }
            
            // Camera Button
            Button {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    showingCamera = true
                } else {
                    alertMessage = "Camera is not available on this device"
                    showingAlert = true
                }
            } label: {
                Label("Take Photo", systemImage: "camera.fill")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(25)
            }
            
            // Clear Button (if image exists)
            if selectedImage != nil {
                Button {
                    selectedImage = nil
                    selectedItem = nil
                } label: {
                    Label("Clear Image", systemImage: "trash")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundStyle(.white)
                        .cornerRadius(25)
                }
            }
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showingCamera) {
            CameraView(image: $selectedImage)
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
}

#Preview {
    ContentView()
}
