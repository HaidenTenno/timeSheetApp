//
//  TimeSheetViewController.swift
//  timeSheetApp
//
//  Created by Петр Тартынских on 02.04.2020.
//  Copyright © 2020 Петр Тартынских. All rights reserved.
//

import UIKit
import SnapKit

class TimeSheetViewController: UIViewController {
    
    // Private
    private let barcodeData: String
    
    // UI
    
    // Services
    
    // Public
    init(barcodeData: String) {
        self.barcodeData = barcodeData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
}

// MARK: - Private
private extension TimeSheetViewController {
    
}

// MARK: - UI
private extension TimeSheetViewController {
    
    private func setupView() {
        // self
        view.backgroundColor = UIColor.red
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        
    }
}
