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
    private func createMainMenuVC() -> ViewController {
        let mainMenuVC = ViewController()
        return mainMenuVC
    }
    
    
    // MARK: - Presetners
    private func presentMainMenuScreen() {
        let mainMenuVC = createMainMenuVC()
        navigationController.pushViewController(mainMenuVC, animated: true)
    }
}
