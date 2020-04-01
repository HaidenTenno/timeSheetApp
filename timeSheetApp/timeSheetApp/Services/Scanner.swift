//
//  Scanner.swift
//  timeSheetApp
//
//  Created by Петр Тартынских on 01.04.2020.
//  Copyright © 2020 Петр Тартынских. All rights reserved.
//

import AVFoundation
import UIKit

final class Scanner: NSObject {
    
    // Private
    private var captureSession: AVCaptureSession?
    private var codeOutputHandler: (_ code: String) -> Void
    
    private let metaObjectTypes: [AVMetadataObject.ObjectType] = [
        .qr,
        .code128,
        .code39,
        .code39Mod43,
        .code93,
        .ean8,
        .interleaved2of5,
        .itf14,
        .pdf417,
        .upce
    ]
    
    // Public
    init(viewController: UIViewController, view: UIView, codeOutputHandler: @escaping (String) -> Void) {
        self.codeOutputHandler = codeOutputHandler
        
        super.init()
        
        guard let captureSession = createCaptureSession(for: viewController) else {
            #if DEBUG
            print("Can't create capture session")
            #endif
            return
        }
        self.captureSession = captureSession
        let previewLayer = createPreviewLayer(withCaptureSession: captureSession, view: view)
        view.layer.addSublayer(previewLayer)
    }
    
    func requestCaptureSessionStartRunning() {
        guard let captureSession = captureSession, !captureSession.isRunning else { return }
        captureSession.startRunning()
    }
    
    func requestCaptureSessionStopRunning() {
        guard let captureSession = captureSession, captureSession.isRunning else { return }
        captureSession.stopRunning()
    }
    
    func scannerDelegate(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Got value from barcode
        requestCaptureSessionStopRunning()
        
        guard let metadataObject = metadataObjects.first else { return }
        
        guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
            #if DEBUG
            print("Can't read metadata object")
            #endif
            return
        }
        guard let stringValue = readableObject.stringValue else {
            #if DEBUG
            print("Can't get string value from readableObject")
            #endif
            return
        }
        
        codeOutputHandler(stringValue)
    }
}

// MARK: - Private
private extension Scanner {
    
    private func createCaptureSession(for viewController: UIViewController) -> AVCaptureSession? {
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return nil }
        
        // Inputs and outputs for to the capture session
        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return nil }
        let metaDataOutput = AVCaptureMetadataOutput()
        
        guard captureSession.canAddInput(deviceInput) else { return nil }
        captureSession.addInput(deviceInput)
        
        guard captureSession.canAddOutput(metaDataOutput) else { return nil }
        captureSession.addOutput(metaDataOutput)
        guard let viewController = viewController as? AVCaptureMetadataOutputObjectsDelegate else { return nil }
        metaDataOutput.setMetadataObjectsDelegate(viewController, queue: DispatchQueue.main)
        metaDataOutput.metadataObjectTypes = metaObjectTypes
        
        return captureSession
    }
    
    private func createPreviewLayer(withCaptureSession captureSession: AVCaptureSession, view: UIView) -> AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        return previewLayer
    }
}
