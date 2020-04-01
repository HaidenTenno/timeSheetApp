//
//  ViewController.swift
//  timeSheetApp
//
//  Created by Петр Тартынских on 24.03.2020.
//  Copyright © 2020 Петр Тартынских. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

class ScannerViewController: UIViewController {
    
    // UI
    
    // Services
    private var scanner: Scanner?
    
    // Callbacks
    private let onBarcodeDetected: (String) -> Void
    
    // Public
    init(onBarcodeDetected: @escaping (String) -> Void) {
        self.onBarcodeDetected = onBarcodeDetected
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScanner()
    }
    
    
}

// MARK: - Private
private extension ScannerViewController {
    
    private func setupScanner() {
        self.scanner = Scanner(viewController: self, view: view, codeOutputHandler: onBarcodeDetected)
        guard let scanner = scanner else {
            #if DEBUG
            print("Can't create scanner")
            #endif
            return
        }
        
        scanner.requestCaptureSessionStartRunning()
    }
}

// MARK: - UI
private extension ScannerViewController {
    
    private func setupView() {
        // self
        view.backgroundColor = UIColor.red
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        scanner?.scannerDelegate(output, didOutput: metadataObjects, from: connection)
    }
}
