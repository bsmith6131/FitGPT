//
//  CameraView.swift
//  FitGPT
//
//  Created by Brian Smith on 7/15/25.
//


import Foundation
import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment (\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController{
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
    }
}
