//
//  MainMenuViewController.swift
//  timeSheetApp
//
//  Created by Петр Тартынских on 02.04.2020.
//  Copyright © 2020 Петр Тартынских. All rights reserved.
//

import UIKit
import SnapKit

class MainMenuViewController: UIViewController {
    
    // UI
    
    // Services
    
    // Callbacks
    private let onLoginRequired: () -> Void
    private let onScanButtonPressed: () -> Void
    
    // Public
    init(onLoginRequired: @escaping () -> Void, onScanButtonPressed: @escaping  () -> Void) {
        self.onLoginRequired = onLoginRequired
        self.onScanButtonPressed = onScanButtonPressed
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
private extension MainMenuViewController {
    
}

// MARK: - UI
private extension MainMenuViewController {
    
    private func setupView() {
        // self
        view.backgroundColor = UIColor.red
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        
    }
}
