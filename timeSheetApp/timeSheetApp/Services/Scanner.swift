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
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
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
    init(delegate: AVCaptureMetadataOutputObjectsDelegate, codeOutputHandler: @escaping (String) -> Void) {
        self.codeOutputHandler = codeOutputHandler
        
        super.init()
        
        guard let captureSession = createCaptureSession(delegate: delegate) else {
            #if DEBUG
            print("Can't create capture session")
            #endif
            return
        }
        self.captureSession = captureSession
    }
    
    func requestCaptureSessionStartRunning(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            guard let captureSession = self.captureSession, !captureSession.isRunning else { return }
            captureSession.startRunning()
            DispatchQueue.main.async {
                completion()
            }
        }
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
    
    func addAsASublayer(forView view: UIView) {
        guard let captureSession = captureSession else { return }
        setupPreviewLayer(forView: view, withCaptureSession: captureSession)
    }
}

// MARK: - Private
private extension Scanner {
    
    private func createCaptureSession(delegate: AVCaptureMetadataOutputObjectsDelegate) -> AVCaptureSession? {
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return nil }
        
        // Inputs and outputs for to the capture session
        guard let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return nil }
        guard captureSession.canAddInput(deviceInput) else { return nil }
        captureSession.addInput(deviceInput)
        
        let metaDataOutput = AVCaptureMetadataOutput()
        guard captureSession.canAddOutput(metaDataOutput) else { return nil }
        captureSession.addOutput(metaDataOutput)
        metaDataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
        metaDataOutput.metadataObjectTypes = metaObjectTypes
        
        return captureSession
    }
    
    private func setupPreviewLayer(forView view: UIView, withCaptureSession captureSession: AVCaptureSession) {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.frame = view.bounds
        
        view.layer.addSublayer(previewLayer)
        
        videoPreviewLayer = previewLayer
    }
}
