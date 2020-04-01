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

class ViewController: UIViewController {
    
    // UI
    
    // Services
    private var scanner: Scanner?
    
    // Public
    init() {
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
private extension ViewController {
    
    private func setupScanner() {
        self.scanner = Scanner(viewController: self, view: view, codeOutputHandler: handeCode(code:))
        guard let scanner = scanner else {
            #if DEBUG
            print("Can't create scanner")
            #endif
            return
        }
        
        scanner.requestCaptureSessionStartRunning()
    }
    
    private func handeCode(code: String) {
        print(code)
    }
    
}

// MARK: - UI
private extension ViewController {
    
    private func setupView() {
        // self
        view.backgroundColor = UIColor.red
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        scanner?.scannerDelegate(output, didOutput: metadataObjects, from: connection)
    }
}
