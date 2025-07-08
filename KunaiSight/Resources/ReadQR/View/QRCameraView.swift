//
//  QRCameraView.swift
//  BioPago
//
//  Created by Ulises Atonatiuh Gonzalez Hernandez  on 30/06/25.
//

import Foundation
import SwiftUI
import UIKit
import AVFoundation

struct QRCameraView: View {
    @StateObject var viewModel = QRCameraViewModel()

    var body: some View {
        ZStack {
            CameraPreview(session: viewModel.session)
                .edgesIgnoringSafeArea(.all)

            if viewModel.isCapturing {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                ProgressView("Procesando...")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(12)
                    .zIndex(10) 
            }

            VStack {
                Spacer()
                Button(action: {
                    viewModel.capturePhoto()
                }) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 70, height: 70)
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                }
                .padding(.bottom, 40)
                .disabled(viewModel.isCapturing) 
            }

            if let result = viewModel.ocrResult {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Merchant: \(result.merchant ?? "N/A")")
                    Text("Amount: \(result.amount ?? "N/A")")
                    Text("Date: \(result.date ?? "N/A")")
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .padding()
            }
        }
        .alert("Fallo en el escaneo", isPresented: $viewModel.showErrorAlert) {
            Button("OK", role: .cancel) {
                // Reset is already handled in ViewModel
            }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}


struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(previewLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let layer = uiView.layer.sublayers?.first(where: { $0 is AVCaptureVideoPreviewLayer }) as? AVCaptureVideoPreviewLayer {
            layer.session = session
        }
    }
}
