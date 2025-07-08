//
//  QRCameraViewModel.swift
//  BioPago
//
//  Created by Ulises Atonatiuh Gonzalez Hernandez  on 30/06/25.
//

import Foundation
import AVFoundation
import Vision
import SwiftUI

class QRCameraViewModel: NSObject, ObservableObject {

    @Published var ocrResult: OCRResultModel?
    @Published var isCapturing = false
    @Published var showErrorAlert = false
    @Published var errorMessage: String = ""
    @Published var session = AVCaptureSession()

    private let output = AVCapturePhotoOutput()

    override init() {
        super.init()
        setupSession()
    }

    func setupSession() {
        session = AVCaptureSession() // reinicia la sesión
        session.beginConfiguration()

        session.inputs.forEach { session.removeInput($0) }
        session.outputs.forEach { session.removeOutput($0) }

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input),
              session.canAddOutput(output) else {
            handleScanFailure(message: "Error al configurar la cámara.")
            return
        }

        session.addInput(input)
        session.addOutput(output)
        session.commitConfiguration()
        DispatchQueue.global(qos: .userInitiated).async {
               self.session.startRunning()
           }
    }

    func capturePhoto() {
        DispatchQueue.main.async {
            self.isCapturing = true
        }

        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }

    private func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else {
            handleScanFailure(message: "No se pudo procesar la imagen.")
            return
        }

        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let self = self else { return }

            if let error = error {
                self.handleScanFailure(message: "Error de reconocimiento: \(error.localizedDescription)")
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation], !observations.isEmpty else {
                self.handleScanFailure(message: "No se detectó texto en la imagen.")
                return
            }

            let lines = observations.compactMap { $0.topCandidates(1).first?.string }
            let parsed = OCRParser.parse(from: lines)

            DispatchQueue.main.async {
                self.ocrResult = parsed
                self.isCapturing = false

                // Limpiar después de 5s
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.ocrResult = nil
                    self.setupSession() // Reinicia la cámara
                }
            }
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            handleScanFailure(message: "Fallo al ejecutar el OCR: \(error.localizedDescription)")
        }
    }

    private func handleScanFailure(message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.showErrorAlert = true
            self.ocrResult = nil
            self.isCapturing = false

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.setupSession()
            }
        }
    }
}


extension QRCameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }

        recognizeText(from: image)
    }
}
