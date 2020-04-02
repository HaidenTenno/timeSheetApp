//
//  ScannerViewController.swift
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
    private var barcodeImageView: UIImageView!
    
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
        setupScanner()
        setupView()
    }
}

// MARK: - Private
private extension ScannerViewController {
    
    private func setupScanner() {
        self.scanner = Scanner(delegate: self, codeOutputHandler: onBarcodeDetected)
        scanner?.addAsASublayer(forView: view)
        scanner?.requestCaptureSessionStartRunning { [unowned self] in
            self.barcodeImageView.isHidden = false
        }
    }
}

// MARK: - UI
private extension ScannerViewController {
    
    private func setupView() {
        
        // self
        view.backgroundColor = Design.Colors.scannerBackgroundColor
        
        // barcodeImageView
        let  barcodeImageConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .light, scale: .large)
        let  barcodeImage = UIImage(systemName: Design.ImageNames.barcodeImage)?
            .withTintColor(Design.Colors.barcodeImageTintColor)
            .withRenderingMode(.alwaysOriginal)
            .withConfiguration(barcodeImageConfig)
        barcodeImageView = UIImageView(image: barcodeImage)
        barcodeImageView.isHidden = true
        view.addSubview(barcodeImageView)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        
        // barcodeImageView
        barcodeImageView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        scanner?.scannerDelegate(output, didOutput: metadataObjects, from: connection)
    }
}
