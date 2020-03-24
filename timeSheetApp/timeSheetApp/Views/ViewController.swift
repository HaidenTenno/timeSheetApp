//
//  ViewController.swift
//  timeSheetApp
//
//  Created by Петр Тартынских on 24.03.2020.
//  Copyright © 2020 Петр Тартынских. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    // UI
    
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
private extension ViewController {
    
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
