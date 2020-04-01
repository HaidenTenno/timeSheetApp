//
//  SignInViewController.swift
//  timeSheetApp
//
//  Created by Петр Тартынских on 02.04.2020.
//  Copyright © 2020 Петр Тартынских. All rights reserved.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController {
    
    // UI
    
    // Services
    
    // Callbacks
    
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
    }
    
    
}

// MARK: - Private
private extension SignInViewController {
    
}

// MARK: - UI
private extension SignInViewController {
    
    private func setupView() {
        // self
        view.backgroundColor = UIColor.red
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        
    }
}
