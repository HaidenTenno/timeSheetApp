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
    private var scanButton: UIButton!
    private var logoutButton: UIButton!
    
    // Services
    private var networkService: NetworkService = NetworkServiceImplementation.shared
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        networkService.delegate = self
    }
}

// MARK: - Private
private extension MainMenuViewController {
    
    @objc private func onScanButtonTouched() {
        onScanButtonPressed()
    }
    
    @objc private func onLogoutButtonTouched() {
        LoadingIndicatorView.show()
        networkService.logout()
    }
}

// MARK: - UI
private extension MainMenuViewController {
    
    private func setupView() {
        // self
        view.backgroundColor = Design.Colors.greenColor
        
        // scanButton
        scanButton = UIButton(type: .system)
        let  scanButtonImageConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .light, scale: .large)
        let  scanButtonImage = UIImage(systemName: Design.ImageNames.scanImage)?
            .withTintColor(Design.Colors.greyColor)
            .withRenderingMode(.alwaysOriginal)
            .withConfiguration(scanButtonImageConfig)
        scanButton.setImage(scanButtonImage, for: .normal)
        scanButton.backgroundColor = Design.Colors.whiteColor
        scanButton.layer.borderWidth = 6
        scanButton.layer.borderColor = Design.Colors.greyColor.cgColor
        scanButton.layer.cornerRadius = 100
        scanButton.addTarget(self, action: #selector(onScanButtonTouched), for: .touchUpInside)
        view.addSubview(scanButton)
        
        // logoutButton
        logoutButton = UIButton(type: .system)
        let logoutButtonImageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light, scale: .large)
        let logoutButtonImage = UIImage(systemName: Design.ImageNames.logoutImage)?
            .withTintColor(Design.Colors.greyColor)
            .withRenderingMode(.alwaysOriginal)
            .withConfiguration(logoutButtonImageConfig)
        logoutButton.setImage(logoutButtonImage, for: .normal)
        logoutButton.addTarget(self, action: #selector(onLogoutButtonTouched), for: .touchUpInside)
        view.addSubview(logoutButton)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        // scanButton
        scanButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
        
        // logoutButton
        logoutButton.snp.makeConstraints { make in
            make.centerX.equalTo(scanButton)
            make.top.equalTo(scanButton.snp.bottom).offset(30)
        }
    }
}

extension MainMenuViewController: NetworkServiceDelegate {
    
    func networkServiceDidLogout(_ networkService: NetworkService) {
        DispatchQueue.main.async { [unowned self] in
            LoadingIndicatorView.hide()
            self.onLoginRequired()
        }
    }
}
