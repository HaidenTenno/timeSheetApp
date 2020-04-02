//
//  ViewsCoordinator.swift
//  timeSheetApp
//
//  Created by Петр Тартынских on 24.03.2020.
//  Copyright © 2020 Петр Тартынских. All rights reserved.
//

import UIKit

final class ViewsCoordinator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
    }
    
    func start() {
        presentMainMenuScreen()
    }
}

// MARK: - Private
private extension ViewsCoordinator {
    
    // MARK: - Creators
    private func createMainMenuVC() -> MainMenuViewController {
        let mainMenuVC = MainMenuViewController(onLoginRequired: presentSignInScreen,
                                                onScanButtonPressed: presentScannerScreen)
        return mainMenuVC
    }
    
    private func createSignInVC() -> SignInViewController {
        let signInVC = SignInViewController()
        return signInVC
    }
    
    private func createScannerVC() -> ScannerViewController {
        let scannerVC = ScannerViewController { [unowned self] barcodeData in
            guard let topVC = self.navigationController.topViewController as? MainMenuViewController else { return }
            topVC.dismiss(animated: true, completion: nil)
            self.presentTimeSheetScreen(barcodeData: barcodeData)
        }
        return scannerVC
    }
    
    private func createTimeSheetScreen(barcodeData: String) -> TimeSheetViewController {
        let timeSheetVC = TimeSheetViewController(barcodeData: barcodeData)
        return timeSheetVC
    }
    
    // MARK: - Presetners
    private func presentMainMenuScreen() {
        let mainMenuVC = createMainMenuVC()
        navigationController.pushViewController(mainMenuVC, animated: true)
    }
    
    private func presentSignInScreen() {
        let signInVC = createSignInVC()
        signInVC.modalPresentationStyle = .fullScreen
        navigationController.present(signInVC, animated: true, completion: nil)
    }
    
    private func presentScannerScreen() {
        let scannerVC = createScannerVC()
        scannerVC.modalPresentationStyle = .automatic
        navigationController.present(scannerVC, animated: true, completion: nil)
    }
    
    private func presentTimeSheetScreen(barcodeData: String) {
        let timeSheetVC = createTimeSheetScreen(barcodeData: barcodeData)
        navigationController.pushViewController(timeSheetVC, animated: true)
    }
}
